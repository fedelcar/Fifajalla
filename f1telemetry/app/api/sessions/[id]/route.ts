import { NextRequest, NextResponse } from 'next/server'
import pool from '@/lib/db'

export async function GET(
  _req: NextRequest,
  { params }: { params: { id: string } },
) {
  const [sessionRes, lapsRes] = await Promise.all([
    pool.query('SELECT * FROM race_sessions WHERE id = $1', [params.id]),
    pool.query(
      'SELECT * FROM laps WHERE race_session_id = $1 ORDER BY car_index, lap_number',
      [params.id],
    ),
  ])

  if (sessionRes.rows.length === 0) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 })
  }

  return NextResponse.json({ session: sessionRes.rows[0], laps: lapsRes.rows })
}
