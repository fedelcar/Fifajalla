import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'

function authenticated(req: NextRequest): boolean {
  const token = req.headers.get('authorization')?.replace('Bearer ', '')
  return !!process.env.F1_API_TOKEN && token === process.env.F1_API_TOKEN
}

export async function POST(req: NextRequest) {
  if (!authenticated(req)) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const body = await req.json()

  const sessionRes = await pool.query(
    'SELECT id FROM race_sessions WHERE session_uid = $1',
    [body.session_uid],
  )
  if (sessionRes.rows.length === 0) {
    return NextResponse.json({ error: 'Session not found' }, { status: 404 })
  }

  const result = await pool.query(
    `INSERT INTO laps (
       race_session_id, car_index, driver_name, team_id, team_name,
       lap_number, lap_time_ms, sector1_ms, sector2_ms, sector3_ms,
       valid, tyre_compound, tyre_age_laps, car_position, is_player,
       tyre_wear_fl, tyre_wear_fr, tyre_wear_rl, tyre_wear_rr,
       ers_deployed_this_lap, telemetry_frames
     ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21)
     RETURNING id`,
    [
      sessionRes.rows[0].id,
      body.car_index,
      body.driver_name,
      body.team_id,
      body.team_name,
      body.lap_number,
      body.lap_time_ms,
      body.sector1_ms,
      body.sector2_ms,
      body.sector3_ms,
      body.valid ?? true,
      body.tyre_compound,
      body.tyre_age_laps,
      body.car_position,
      body.is_player ?? false,
      body.tyre_wear_fl,
      body.tyre_wear_fr,
      body.tyre_wear_rl,
      body.tyre_wear_rr,
      body.ers_deployed_this_lap,
      body.telemetry_frames ? JSON.stringify(body.telemetry_frames) : null,
    ],
  )

  return NextResponse.json({ id: result.rows[0].id }, { status: 201 })
}
