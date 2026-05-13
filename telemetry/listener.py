#!/usr/bin/env python3
"""
F1 25 UDP Telemetry Listener
----------------------------
Run this on your Mac while playing F1 25 on PS5.

Setup:
  1. Copy .env.example to .env and fill in the values.
  2. In F1 25: Settings → Telemetry → UDP Telemetry ON
               IP Address: your Mac's local IP
               Port: 20777 (default)
               Send Rate: 60Hz
               Format: 2025

  3. Run:  python3 telemetry/listener.py

What it captures for every completed lap:
  - Lap time + sector times
  - Tyre compound, age, wear (FL/FR/RL/RR)
  - ERS deployed this lap
  - Telemetry trace: speed, throttle, brake, gear, steering, DRS vs. distance
    (player car only, downsampled to ~10 Hz to keep storage manageable)
  - All 20 cars' lap times and sector times

Adjust SAMPLE_EVERY to change how many frames are skipped between samples
(higher = fewer data points, smaller payload). At 60 Hz, SAMPLE_EVERY=6 → 10 Hz.
"""

import json
import os
import socket
import time
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from typing import Optional

from packets import (
    HEADER_SIZE,
    PACKET_CAR_DAMAGE,
    PACKET_CAR_STATUS,
    PACKET_CAR_TELEMETRY,
    PACKET_LAP_DATA,
    PACKET_PARTICIPANTS,
    PACKET_SESSION,
    CarDamage,
    CarStatus,
    CarTelemetry,
    LapData,
    parse_car_damage,
    parse_car_status,
    parse_car_telemetry,
    parse_header,
    parse_lap_data,
    parse_participants,
    parse_session,
)

# ---------------------------------------------------------------------------
# Config — override with environment variables or a .env file
# ---------------------------------------------------------------------------
try:
    from dotenv import load_dotenv
    load_dotenv(os.path.join(os.path.dirname(__file__), '.env'))
except ImportError:
    pass  # dotenv optional; set env vars manually if needed

UDP_PORT      = int(os.environ.get('UDP_PORT', 20777))
API_BASE_URL  = os.environ.get('API_BASE_URL', 'http://localhost:3000/api')
API_TOKEN     = os.environ.get('F1_API_TOKEN', 'change-me-to-a-random-secret')
SAMPLE_EVERY  = int(os.environ.get('SAMPLE_EVERY', 6))   # keep 1-in-N telemetry frames
VERBOSE       = os.environ.get('VERBOSE', '').lower() in ('1', 'true', 'yes')

# ---------------------------------------------------------------------------
# State machine
# ---------------------------------------------------------------------------

@dataclass
class TelemetryFrame:
    d:      float   # lap distance (m)
    spd:    int     # speed (km/h)
    thr:    float   # throttle 0–1
    brk:    float   # brake 0–1
    gear:   int
    steer:  float   # -1 to 1
    drs:    int
    rpm:    int
    sector: int     # 0/1/2

    def as_dict(self):
        return {
            'd':     round(self.d, 1),
            'spd':   self.spd,
            'thr':   round(self.thr, 3),
            'brk':   round(self.brk, 3),
            'gear':  self.gear,
            'steer': round(self.steer, 3),
            'drs':   self.drs,
            'rpm':   self.rpm,
            'sector': self.sector,
        }


@dataclass
class State:
    # Session
    session_uid:    int   = 0
    track_id:       int   = -1
    session_type:   int   = 0
    weather:        int   = 0
    ai_difficulty:  int   = 50
    total_laps:     int   = 0
    track_length:   int   = 0
    game_year:      int   = 2025
    session_posted: bool  = False

    # Participants (car_index → info)
    participants: dict = field(default_factory=dict)

    # Per-car lap tracking
    lap_nums:     dict = field(default_factory=dict)   # car_index → int
    lap_distance: dict = field(default_factory=dict)   # car_index → float

    # Per-car latest sector times (captured when sector field changes)
    sector1_ms:   dict = field(default_factory=dict)   # car_index → int
    sector2_ms:   dict = field(default_factory=dict)

    # Per-car tyre / status
    tyre_compound: dict = field(default_factory=dict)
    tyre_age:      dict = field(default_factory=dict)
    tyre_wear_fl:  dict = field(default_factory=dict)
    tyre_wear_fr:  dict = field(default_factory=dict)
    tyre_wear_rl:  dict = field(default_factory=dict)
    tyre_wear_rr:  dict = field(default_factory=dict)
    ers_deployed:  dict = field(default_factory=dict)

    # Player telemetry buffer for the current lap
    telemetry_frames:    list = field(default_factory=list)
    frame_counter:       int  = 0   # counts received CarTelemetry packets
    current_sector:      dict = field(default_factory=dict)  # car_index → sector


state = State()


# ---------------------------------------------------------------------------
# API helpers
# ---------------------------------------------------------------------------

def api_post(path: str, payload: dict) -> Optional[dict]:
    url  = f'{API_BASE_URL}{path}'
    data = json.dumps(payload).encode()
    req  = urllib.request.Request(
        url,
        data=data,
        method='POST',
        headers={
            'Content-Type':  'application/json',
            'Authorization': f'Bearer {API_TOKEN}',
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=5) as resp:
            body = json.loads(resp.read())
            if VERBOSE:
                print(f'  → POST {path} {resp.status} {body}')
            return body
    except urllib.error.HTTPError as e:
        print(f'  ✗ POST {path} HTTP {e.code}: {e.read().decode()[:200]}')
    except Exception as e:
        print(f'  ✗ POST {path} error: {e}')
    return None


def ensure_session_posted():
    if state.session_posted:
        return
    print(f'[SESSION] track_id={state.track_id}  type={state.session_type}'
          f'  ai={state.ai_difficulty}  uid={state.session_uid}')
    result = api_post('/sessions', {
        'session_uid':  str(state.session_uid),
        'track_id':     state.track_id,
        'session_type': state.session_type,
        'weather':      state.weather,
        'ai_difficulty': state.ai_difficulty,
        'total_laps':   state.total_laps,
        'game_year':    state.game_year,
        'track_length': state.track_length,
    })
    if result:
        state.session_posted = True


def post_lap(
    car_index:      int,
    lap_number:     int,
    lap_time_ms:    int,
    sector1_ms:     int,
    sector2_ms:     int,
    sector3_ms:     int,
    valid:          bool,
    car_position:   int,
    is_player:      bool,
    frames:         Optional[list],
):
    part = state.participants.get(car_index, {})
    payload = {
        'session_uid':       str(state.session_uid),
        'car_index':         car_index,
        'driver_name':       part.get('name', f'Car {car_index}'),
        'team_id':           part.get('team_id', 255),
        'team_name':         part.get('team_name', 'Unknown'),
        'lap_number':        lap_number,
        'lap_time_ms':       lap_time_ms,
        'sector1_ms':        sector1_ms,
        'sector2_ms':        sector2_ms,
        'sector3_ms':        sector3_ms,
        'valid':             valid,
        'tyre_compound':     state.tyre_compound.get(car_index),
        'tyre_age_laps':     state.tyre_age.get(car_index),
        'car_position':      car_position,
        'is_player':         is_player,
        'tyre_wear_fl':      state.tyre_wear_fl.get(car_index),
        'tyre_wear_fr':      state.tyre_wear_fr.get(car_index),
        'tyre_wear_rl':      state.tyre_wear_rl.get(car_index),
        'tyre_wear_rr':      state.tyre_wear_rr.get(car_index),
        'ers_deployed_this_lap': state.ers_deployed.get(car_index),
        'telemetry_frames':  frames,
    }
    label = 'PLAYER' if is_player else f'car#{car_index}'
    t_str = f'{lap_time_ms/1000:.3f}s' if lap_time_ms else 'no time'
    print(f'  [LAP] {label}  lap={lap_number}  {t_str}'
          f'  valid={valid}  pos=P{car_position}'
          + (f'  frames={len(frames)}' if frames else ''))
    api_post('/laps', payload)


# ---------------------------------------------------------------------------
# Packet handlers
# ---------------------------------------------------------------------------

TEAM_NAMES = {
    0: 'Mercedes', 1: 'Ferrari', 2: 'Red Bull', 3: 'Williams',
    4: 'Aston Martin', 5: 'Alpine', 6: 'RB', 7: 'Haas', 8: 'McLaren',
    9: 'Sauber', 85: 'My Team',
}


def handle_session(data: bytes):
    info = parse_session(data)
    if not info:
        return

    header     = parse_header(data)
    new_uid    = header.session_uid
    new_year   = header.game_year

    if new_uid != state.session_uid:
        # New session — reset everything
        print(f'\n[NEW SESSION] uid={new_uid}  year={new_year}'
              f'  track={info.track_id}  type={info.session_type}')
        state.session_uid    = new_uid
        state.game_year      = new_year
        state.session_posted = False
        state.participants   = {}
        state.lap_nums       = {}
        state.sector1_ms     = {}
        state.sector2_ms     = {}
        state.telemetry_frames = []
        state.frame_counter  = 0
        state.current_sector = {}

    state.track_id      = info.track_id
    state.session_type  = info.session_type
    state.weather       = info.weather
    state.ai_difficulty = info.ai_difficulty
    state.total_laps    = info.total_laps
    state.track_length  = info.track_length

    ensure_session_posted()


def handle_participants(data: bytes, player_idx: int):
    parts = parse_participants(data)
    if not parts:
        return
    for i, p in enumerate(parts):
        state.participants[i] = {
            'name':      p.name,
            'team_id':   p.team_id,
            'team_name': TEAM_NAMES.get(p.team_id, f'Team {p.team_id}'),
        }
        if VERBOSE and i == player_idx:
            print(f'  [PART] player={p.name}  team={p.team_id}')


def handle_lap_data(data: bytes, player_idx: int):
    laps = parse_lap_data(data)
    if not laps:
        return
    if not state.session_posted:
        return

    for car_idx, ld in enumerate(laps):
        if ld.result_status == 0:   # not in race
            continue

        prev_lap = state.lap_nums.get(car_idx, 0)
        curr_lap = ld.current_lap_num
        state.lap_distance[car_idx] = ld.lap_distance

        # Track current sector
        state.current_sector[car_idx] = ld.sector

        # Capture sector times while in progress
        if ld.sector >= 1 and ld.sector1_total_ms > 0:
            state.sector1_ms[car_idx] = ld.sector1_total_ms
        if ld.sector >= 2 and ld.sector2_total_ms > 0:
            state.sector2_ms[car_idx] = ld.sector2_total_ms

        if curr_lap > prev_lap and prev_lap > 0 and ld.last_lap_time_ms > 0:
            # A lap just completed
            s1  = state.sector1_ms.get(car_idx, 0)
            s2  = state.sector2_ms.get(car_idx, 0)
            s3  = max(0, ld.last_lap_time_ms - s1 - s2) if (s1 and s2) else 0
            valid = ld.current_lap_invalid == 0

            is_player = (car_idx == player_idx)
            frames = None
            if is_player:
                frames = [f.as_dict() for f in state.telemetry_frames]
                state.telemetry_frames = []
                state.frame_counter    = 0

            post_lap(
                car_index    = car_idx,
                lap_number   = prev_lap,
                lap_time_ms  = ld.last_lap_time_ms,
                sector1_ms   = s1,
                sector2_ms   = s2,
                sector3_ms   = s3,
                valid        = valid,
                car_position = ld.car_position,
                is_player    = is_player,
                frames       = frames,
            )

            # Reset sector tracking for this car
            state.sector1_ms.pop(car_idx, None)
            state.sector2_ms.pop(car_idx, None)

        state.lap_nums[car_idx] = curr_lap


def handle_car_telemetry(data: bytes, player_idx: int):
    cars = parse_car_telemetry(data)
    if not cars or not state.session_posted:
        return

    state.frame_counter += 1
    if state.frame_counter % SAMPLE_EVERY != 0:
        return  # subsample

    ct = cars[player_idx]
    dist = state.lap_distance.get(player_idx, 0.0)
    sector = state.current_sector.get(player_idx, 0)

    state.telemetry_frames.append(TelemetryFrame(
        d=dist,
        spd=ct.speed,
        thr=ct.throttle,
        brk=ct.brake,
        gear=ct.gear,
        steer=ct.steer,
        drs=ct.drs,
        rpm=ct.engine_rpm,
        sector=sector,
    ))


def handle_car_status(data: bytes):
    cars = parse_car_status(data)
    if not cars:
        return
    for i, cs in enumerate(cars):
        state.tyre_compound[i] = cs.actual_tyre_compound
        state.tyre_age[i]      = cs.tyres_age_laps
        state.ers_deployed[i]  = cs.ers_deployed_this_lap


def handle_car_damage(data: bytes):
    cars = parse_car_damage(data)
    if not cars:
        return
    for i, cd in enumerate(cars):
        state.tyre_wear_fl[i] = cd.tyre_wear_fl
        state.tyre_wear_fr[i] = cd.tyre_wear_fr
        state.tyre_wear_rl[i] = cd.tyre_wear_rl
        state.tyre_wear_rr[i] = cd.tyre_wear_rr


# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(('', UDP_PORT))
    sock.settimeout(1.0)

    print('═' * 60)
    print(f'  F1 25 Telemetry Listener')
    print(f'  Listening on UDP port {UDP_PORT}')
    print(f'  Posting to            {API_BASE_URL}')
    print(f'  Telemetry sample rate 1-in-{SAMPLE_EVERY} frames (~{60//SAMPLE_EVERY} Hz)')
    print('═' * 60)
    print()
    print('Waiting for F1 25 packets...')
    print('(In F1 25: Settings → Telemetry → UDP On, IP = this Mac, Port = 20777)')
    print()

    packets_received = 0
    last_status      = time.time()

    while True:
        try:
            data, _ = sock.recvfrom(4096)
        except socket.timeout:
            # Print a heartbeat every 30s while idle
            if time.time() - last_status > 30:
                print('  … waiting for packets …')
                last_status = time.time()
            continue
        except KeyboardInterrupt:
            print('\nStopped.')
            break

        header = parse_header(data)
        if not header:
            continue

        packets_received += 1
        player_idx = header.player_car_index

        pid = header.packet_id
        try:
            if   pid == PACKET_SESSION:       handle_session(data)
            elif pid == PACKET_PARTICIPANTS:   handle_participants(data, player_idx)
            elif pid == PACKET_LAP_DATA:       handle_lap_data(data, player_idx)
            elif pid == PACKET_CAR_TELEMETRY:  handle_car_telemetry(data, player_idx)
            elif pid == PACKET_CAR_STATUS:     handle_car_status(data)
            elif pid == PACKET_CAR_DAMAGE:     handle_car_damage(data)
        except Exception as exc:
            print(f'  ✗ Error handling packet_id={pid}: {exc}')
            if VERBOSE:
                import traceback; traceback.print_exc()

        if VERBOSE and packets_received % 600 == 0:
            print(f'  [dbg] {packets_received} packets received')


if __name__ == '__main__':
    main()
