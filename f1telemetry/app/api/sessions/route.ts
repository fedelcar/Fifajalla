import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'
import { TRACK_NAMES, SESSION_TYPES } from '@/lib/constants'

function authenticated(req: NextRequest): boolean {
  const token = req.headers.get('authorization')?.replace('Bearer ', '')
  return !!process.env.F1_API_TOKEN && token === process.env.F1_API_TOKEN
}

export async function POST(req: NextRequest) {
  if (!authenticated(req)) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const body = await req.json()
  const {
    session_uid, track_id, session_type, weather,
    ai_difficulty, total_laps, game_year, track_length,
  } = body

  const track_name       = TRACK_NAMES[Number(track_id)]       ?? 'Unknown'
  const session_type_name = SESSION_TYPES[Number(session_type)] ?? 'Unknown'

  const result = await pool.query(
    `INSERT INTO race_sessions
       (session_uid, track_id, track_name, session_type, session_type_name,
        weather, ai_difficulty, total_laps, game_year, track_length)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
     ON CONFLICT (session_uid) DO UPDATE SET
       track_id          = EXCLUDED.track_id,
       track_name        = EXCLUDED.track_name,
       session_type      = EXCLUDED.session_type,
       session_type_name = EXCLUDED.session_type_name,
       weather           = EXCLUDED.weather,
       ai_difficulty     = EXCLUDED.ai_difficulty,
       total_laps        = EXCLUDED.total_laps
     RETURNING id`,
    [session_uid, track_id, track_name, session_type, session_type_name,
     weather, ai_difficulty, total_laps, game_year, track_length],
  )

  return NextResponse.json({ id: result.rows[0].id })
}

export async function GET() {
  const result = await pool.query(`
    SELECT
      rs.*,
      (SELECT lap_time_ms FROM laps
       WHERE race_session_id = rs.id AND is_player AND valid AND lap_time_ms > 0
       ORDER BY lap_time_ms LIMIT 1) AS best_lap_ms,
      (SELECT COUNT(*)::int FROM laps
       WHERE race_session_id = rs.id AND is_player) AS player_lap_count
    FROM race_sessions rs
    ORDER BY rs.started_at DESC
    LIMIT 200
  `)
  return NextResponse.json(result.rows)
}
