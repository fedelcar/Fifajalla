import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'

export async function GET(
  _req: NextRequest,
  { params }: { params: { id: string } },
) {
  const result = await pool.query(
    `SELECT l.*, rs.track_name, rs.session_type_name, rs.ai_difficulty, rs.id AS session_id
     FROM laps l
     JOIN race_sessions rs ON rs.id = l.race_session_id
     WHERE l.id = $1`,
    [params.id],
  )

  if (result.rows.length === 0) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 })
  }

  return NextResponse.json(result.rows[0])
}
