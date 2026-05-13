"""
F1 25 UDP Telemetry packet definitions.

Based on the EA F1 24 UDP spec, which F1 25 follows closely.
If any packet sizes are off, download the official spec PDF from:
  https://answers.ea.com/t5/General-Discussion/F1-24-UDP-Specification/td-p/13745220
and adjust the FORMAT strings below accordingly.

All formats are little-endian ('<').
"""

import struct
from dataclasses import dataclass, field
from typing import Optional

# ---------------------------------------------------------------------------
# Header — 29 bytes, present at the start of every packet
# ---------------------------------------------------------------------------
HEADER_FMT  = '<HBBBBBQfIIBB'
HEADER_SIZE = struct.calcsize(HEADER_FMT)  # 29

@dataclass
class PacketHeader:
    packet_format:              int   # 2025 for F1 25
    game_year:                  int
    game_major_version:         int
    game_minor_version:         int
    packet_version:             int
    packet_id:                  int   # see PACKET_IDs below
    session_uid:                int   # unique session identifier
    session_time:               float
    frame_identifier:           int
    overall_frame_identifier:   int
    player_car_index:           int   # 0-19
    secondary_player_car_index: int   # 255 = no second player


def parse_header(data: bytes) -> Optional[PacketHeader]:
    if len(data) < HEADER_SIZE:
        return None
    fields = struct.unpack_from(HEADER_FMT, data, 0)
    return PacketHeader(*fields)


# Packet ID constants
PACKET_MOTION       = 0
PACKET_SESSION      = 1
PACKET_LAP_DATA     = 2
PACKET_EVENT        = 3
PACKET_PARTICIPANTS = 4
PACKET_CAR_SETUPS   = 5
PACKET_CAR_TELEMETRY = 6
PACKET_CAR_STATUS   = 7
PACKET_FINAL_CLASS  = 8
PACKET_LOBBY_INFO   = 9
PACKET_CAR_DAMAGE   = 10
PACKET_SESSION_HIST = 11
PACKET_TYRE_SETS    = 12
PACKET_MOTION_EX    = 13


# ---------------------------------------------------------------------------
# Session Data (packet_id = 1)
# We only need the first ~20 bytes after the header.
# ---------------------------------------------------------------------------
SESSION_PARTIAL_FMT  = '<BbbBHBb'   # weather, trackTemp, airTemp, totalLaps, trackLength, sessionType, trackId
SESSION_PARTIAL_SIZE = struct.calcsize(SESSION_PARTIAL_FMT)  # 9

# ai_difficulty is 74 bytes into the session data body in F1 24.
# Layout (offsets from start of body, i.e. after header):
#   0  B  weather
#   1  b  track_temperature
#   2  b  air_temperature
#   3  B  total_laps
#   4  H  track_length (2 bytes)
#   6  B  session_type
#   7  b  track_id
#   8  B  formula
#   9  H  session_time_left
#  11  H  session_duration
#  13  B  pit_speed_limit
#  14  B  game_paused
#  15  B  is_spectating
#  16  B  spectator_car_index
#  17  B  sli_pro_native_support
#  18  B  num_marshal_zones
#  19  MarshalZone[21] = 21 * 5 = 105 bytes  → offset 124
# 124  B  safety_car_status
# 125  B  network_game
# 126  B  num_weather_forecast_samples
# 127  WeatherForecastSample[56] = 56 * 8 = 448 bytes → offset 575
# 575  B  forecast_accuracy
# 576  B  ai_difficulty   ← THIS IS WHAT WE WANT

SESSION_AI_DIFF_OFFSET = HEADER_SIZE + 576   # absolute byte offset in full packet

@dataclass
class SessionInfo:
    weather:       int
    total_laps:    int
    track_length:  int
    session_type:  int
    track_id:      int
    ai_difficulty: int


def parse_session(data: bytes) -> Optional[SessionInfo]:
    body_start = HEADER_SIZE
    if len(data) < body_start + SESSION_PARTIAL_SIZE:
        return None

    weather, _, _, total_laps, track_length, session_type, track_id = struct.unpack_from(
        SESSION_PARTIAL_FMT, data, body_start
    )

    ai_difficulty = 50  # default if packet too short
    if len(data) > SESSION_AI_DIFF_OFFSET:
        ai_difficulty = struct.unpack_from('<B', data, SESSION_AI_DIFF_OFFSET)[0]

    return SessionInfo(
        weather=weather,
        total_laps=total_laps,
        track_length=track_length,
        session_type=session_type,
        track_id=track_id,
        ai_difficulty=ai_difficulty,
    )


# ---------------------------------------------------------------------------
# Lap Data (packet_id = 2)
# 55 bytes per car × 20 cars = 1100 bytes body (F1 24)
# ---------------------------------------------------------------------------
LAP_DATA_PER_CAR_FMT  = '<IIHBHBHHfffBBBBBBBBBBBBBBBHHBfB'
LAP_DATA_PER_CAR_SIZE = struct.calcsize(LAP_DATA_PER_CAR_FMT)  # 55

@dataclass
class LapData:
    last_lap_time_ms:           int
    current_lap_time_ms:        int
    sector1_time_ms_part:       int
    sector1_time_min_part:      int
    sector2_time_ms_part:       int
    sector2_time_min_part:      int
    delta_to_front_ms:          int
    delta_to_leader_ms:         int
    lap_distance:               float
    total_distance:             float
    safety_car_delta:           float
    car_position:               int
    current_lap_num:            int
    pit_status:                 int
    num_pit_stops:              int
    sector:                     int   # 0, 1, or 2
    current_lap_invalid:        int   # 1 = invalid
    penalties:                  int
    total_warnings:             int
    corner_cutting_warnings:    int
    num_unserved_dt_pens:       int
    num_unserved_sg_pens:       int
    grid_position:              int
    driver_status:              int   # 0=garage,1=flying,2=inlap,3=outlap,4=track
    result_status:              int
    pit_lane_timer_active:      int
    pit_lane_time_ms:           int
    pit_stop_timer_ms:          int
    pit_stop_should_serve_pen:  int
    speed_trap_fastest_speed:   float
    speed_trap_fastest_lap:     int

    @property
    def sector1_total_ms(self) -> int:
        return self.sector1_time_min_part * 60000 + self.sector1_time_ms_part

    @property
    def sector2_total_ms(self) -> int:
        return self.sector2_time_min_part * 60000 + self.sector2_time_ms_part


def parse_lap_data(data: bytes) -> Optional[list[LapData]]:
    body_start = HEADER_SIZE
    if len(data) < body_start + LAP_DATA_PER_CAR_SIZE * 20:
        return None

    laps = []
    for i in range(20):
        offset = body_start + i * LAP_DATA_PER_CAR_SIZE
        fields = struct.unpack_from(LAP_DATA_PER_CAR_FMT, data, offset)
        laps.append(LapData(*fields))
    return laps


# ---------------------------------------------------------------------------
# Participants (packet_id = 4)
# 1 byte numActiveCars + 60 bytes per car
# ---------------------------------------------------------------------------
PARTICIPANT_PER_CAR_FMT  = '<BBBBBBBx48sBBHB'
PARTICIPANT_PER_CAR_SIZE = struct.calcsize(PARTICIPANT_PER_CAR_FMT)  # 60

# Note: 'x' is 1 pad byte (to align name field); adjust if sizes differ.
# Simpler: parse with a manual slice approach to avoid padding confusion.
_PART_HEADER_FMT  = '<BBBBBBB'   # 7 bytes before the name
_PART_HEADER_SIZE = 7
_PART_NAME_SIZE   = 48
_PART_TRAIL_FMT   = '<BBHB'      # 5 bytes after the name
_PART_TRAIL_SIZE  = struct.calcsize(_PART_TRAIL_FMT)
PARTICIPANT_STRIDE = _PART_HEADER_SIZE + _PART_NAME_SIZE + _PART_TRAIL_SIZE  # 60

@dataclass
class Participant:
    ai_controlled: int
    driver_id:     int
    network_id:    int
    team_id:       int
    my_team:       int
    race_number:   int
    nationality:   int
    name:          str
    your_telemetry: int
    show_online_names: int
    tech_level:    int
    platform:      int


def parse_participants(data: bytes) -> Optional[list[Participant]]:
    body_start = HEADER_SIZE
    if len(data) < body_start + 1:
        return None

    num_active = struct.unpack_from('<B', data, body_start)[0]
    participants = []
    offset = body_start + 1

    for i in range(min(num_active, 20)):
        if offset + PARTICIPANT_STRIDE > len(data):
            break
        hdr = struct.unpack_from(_PART_HEADER_FMT, data, offset)
        name_raw = data[offset + _PART_HEADER_SIZE: offset + _PART_HEADER_SIZE + _PART_NAME_SIZE]
        name = name_raw.rstrip(b'\x00').decode('utf-8', errors='replace')
        trail_offset = offset + _PART_HEADER_SIZE + _PART_NAME_SIZE
        trail = struct.unpack_from(_PART_TRAIL_FMT, data, trail_offset)
        participants.append(Participant(*hdr, name, *trail))
        offset += PARTICIPANT_STRIDE

    return participants


# ---------------------------------------------------------------------------
# Car Telemetry (packet_id = 6)
# 60 bytes per car × 20 = 1200 bytes + 3 bytes footer
# ---------------------------------------------------------------------------
CAR_TELEMETRY_PER_CAR_FMT  = '<HfffBbHBBHHHHHBBBBBBBBHffffBBBB'
CAR_TELEMETRY_PER_CAR_SIZE = struct.calcsize(CAR_TELEMETRY_PER_CAR_FMT)  # 60

@dataclass
class CarTelemetry:
    speed:                   int    # km/h
    throttle:                float  # 0–1
    steer:                   float  # -1 to 1
    brake:                   float  # 0–1
    clutch:                  int
    gear:                    int    # -1=rev, 0=neutral, 1–8
    engine_rpm:              int
    drs:                     int    # 0 or 1
    rev_lights_percent:      int
    rev_lights_bit_value:    int
    brakes_temp_rl:          int
    brakes_temp_rr:          int
    brakes_temp_fl:          int
    brakes_temp_fr:          int
    tyres_surface_temp_rl:   int
    tyres_surface_temp_rr:   int
    tyres_surface_temp_fl:   int
    tyres_surface_temp_fr:   int
    tyres_inner_temp_rl:     int
    tyres_inner_temp_rr:     int
    tyres_inner_temp_fl:     int
    tyres_inner_temp_fr:     int
    engine_temperature:      int
    tyres_pressure_rl:       float
    tyres_pressure_rr:       float
    tyres_pressure_fl:       float
    tyres_pressure_fr:       float
    surface_type_rl:         int
    surface_type_rr:         int
    surface_type_fl:         int
    surface_type_fr:         int


def parse_car_telemetry(data: bytes) -> Optional[list[CarTelemetry]]:
    body_start = HEADER_SIZE
    needed = body_start + CAR_TELEMETRY_PER_CAR_SIZE * 20 + 3
    if len(data) < needed - 3:  # footer optional
        return None

    cars = []
    for i in range(20):
        offset = body_start + i * CAR_TELEMETRY_PER_CAR_SIZE
        if offset + CAR_TELEMETRY_PER_CAR_SIZE > len(data):
            break
        fields = struct.unpack_from(CAR_TELEMETRY_PER_CAR_FMT, data, offset)
        cars.append(CarTelemetry(*fields))
    return cars


# ---------------------------------------------------------------------------
# Car Status (packet_id = 7)
# 55 bytes per car × 20 cars
# Gives: actual tyre compound, visual tyre compound, tyre age, ERS deployed
# ---------------------------------------------------------------------------
CAR_STATUS_PER_CAR_FMT  = '<BBBBBfffHHBbHBBBbfffBfffB'
CAR_STATUS_PER_CAR_SIZE = struct.calcsize(CAR_STATUS_PER_CAR_FMT)  # 55

@dataclass
class CarStatus:
    traction_control:       int
    anti_lock_brakes:       int
    fuel_mix:               int
    front_brake_bias:       int
    pit_limiter_status:     int
    fuel_in_tank:           float
    fuel_capacity:          float
    fuel_remaining_laps:    float
    max_rpm:                int
    idle_rpm:               int
    max_gears:              int
    drs_allowed:            int
    drs_activation_distance: int
    actual_tyre_compound:   int   # 16=Soft,17=Med,18=Hard,7=Inter,8=Wet
    visual_tyre_compound:   int
    tyres_age_laps:         int
    vehicle_fia_flags:      int
    engine_power_ice:       float
    engine_power_mguk:      float
    ers_store_energy:       float
    ers_deploy_mode:        int
    ers_harvested_mguk:     float
    ers_harvested_mguh:     float
    ers_deployed_this_lap:  float  # joules
    network_paused:         int


def parse_car_status(data: bytes) -> Optional[list[CarStatus]]:
    body_start = HEADER_SIZE
    if len(data) < body_start + CAR_STATUS_PER_CAR_SIZE * 20:
        return None

    cars = []
    for i in range(20):
        offset = body_start + i * CAR_STATUS_PER_CAR_SIZE
        fields = struct.unpack_from(CAR_STATUS_PER_CAR_FMT, data, offset)
        cars.append(CarStatus(*fields))
    return cars


# ---------------------------------------------------------------------------
# Car Damage (packet_id = 10)
# Per car: tyresDamage[4] float = tyre wear %, brakesDamage[4] float, + uint8 × 14
# Total per car: 16 + 16 + 14 = 46 bytes
# ---------------------------------------------------------------------------
CAR_DAMAGE_PER_CAR_FMT  = '<4f4f14B'
CAR_DAMAGE_PER_CAR_SIZE = struct.calcsize(CAR_DAMAGE_PER_CAR_FMT)  # 46

@dataclass
class CarDamage:
    # tyre wear/damage percentages (RL, RR, FL, FR order in F1 24)
    tyre_wear_rl:   float
    tyre_wear_rr:   float
    tyre_wear_fl:   float
    tyre_wear_fr:   float
    # brakes damage
    brakes_damage_rl: float
    brakes_damage_rr: float
    brakes_damage_fl: float
    brakes_damage_fr: float
    # uint8 fields (wing/engine/etc.) — stored as tuple
    misc: tuple


def parse_car_damage(data: bytes) -> Optional[list[CarDamage]]:
    body_start = HEADER_SIZE
    if len(data) < body_start + CAR_DAMAGE_PER_CAR_SIZE * 20:
        return None

    cars = []
    for i in range(20):
        offset = body_start + i * CAR_DAMAGE_PER_CAR_SIZE
        fields = struct.unpack_from(CAR_DAMAGE_PER_CAR_FMT, data, offset)
        # fields: (trl,trr,tfl,tfr, brl,brr,bfl,bfr, ...14 bytes...)
        cars.append(CarDamage(
            tyre_wear_rl=fields[0],
            tyre_wear_rr=fields[1],
            tyre_wear_fl=fields[2],
            tyre_wear_fr=fields[3],
            brakes_damage_rl=fields[4],
            brakes_damage_rr=fields[5],
            brakes_damage_fl=fields[6],
            brakes_damage_fr=fields[7],
            misc=fields[8:],
        ))
    return cars
