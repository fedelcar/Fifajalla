import Link from 'next/link'
import pool from '@/lib/db'
import { formatLapTime, formatDate } from '@/lib/utils'
import { WEATHER, SESSION_TYPE_COLORS } from '@/lib/constants'

async function getSessions() {
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
  return result.rows
}

export const dynamic = 'force-dynamic'

export default async function SessionsPage() {
  const sessions = await getSessions()

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-2xl font-bold">Sessions</h1>
        <span className="text-sm text-gray-500">{sessions.length} sessions recorded</span>
      </div>

      {sessions.length === 0 ? (
        <div className="text-center py-24 text-gray-500 border border-dashed border-gray-800 rounded-2xl">
          <p className="text-4xl mb-4">🏁</p>
          <p className="text-lg font-medium text-gray-400 mb-2">No sessions yet</p>
          <p className="text-sm">Start the Python listener, then load into F1 25 to capture your first session.</p>
          <code className="mt-4 block text-xs bg-gray-900 text-green-400 px-4 py-2 rounded-lg inline-block">
            python telemetry/listener.py
          </code>
        </div>
      ) : (
        <div className="space-y-3">
          {sessions.map((s: any) => (
            <Link key={s.id} href={`/sessions/${s.id}`} className="block">
              <div className="bg-gray-900 border border-gray-800 rounded-xl p-5 hover:border-gray-600 transition-all hover:bg-gray-900/80 group">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <h2 className="font-semibold text-base group-hover:text-white">
                          {s.track_name}
                        </h2>
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${SESSION_TYPE_COLORS[s.session_type_name] ?? 'bg-gray-800 text-gray-400'}`}>
                          {s.session_type_name}
                        </span>
                      </div>
                      <div className="flex items-center gap-3 text-sm text-gray-500">
                        <span>AI <span className="text-gray-300 font-medium">{s.ai_difficulty}</span></span>
                        <span>·</span>
                        <span>{WEATHER[s.weather] ?? '—'}</span>
                        <span>·</span>
                        <span>{s.player_lap_count} laps</span>
                        <span>·</span>
                        <span>{formatDate(s.started_at)}</span>
                      </div>
                    </div>
                  </div>

                  <div className="text-right">
                    <div className="text-lg font-mono font-bold text-green-400">
                      {formatLapTime(s.best_lap_ms)}
                    </div>
                    <div className="text-xs text-gray-600 mt-0.5">best lap</div>
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
