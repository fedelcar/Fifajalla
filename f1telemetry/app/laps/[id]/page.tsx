import Link from 'next/link'
import { notFound } from 'next/navigation'
import pool from '@/lib/db'
import { formatLapTime, formatSectorTime } from '@/lib/utils'
import { TYRE_COMPOUNDS } from '@/lib/constants'
import TelemetryChart from '@/components/TelemetryChart'
import TireWearChart from '@/components/TireWearChart'

export const dynamic = 'force-dynamic'

async function getLap(id: string) {
  const result = await pool.query(
    `SELECT l.*, rs.track_name, rs.session_type_name, rs.ai_difficulty, rs.id AS session_id
     FROM laps l
     JOIN race_sessions rs ON rs.id = l.race_session_id
     WHERE l.id = $1`,
    [id],
  )
  return result.rows[0] ?? null
}

export default async function LapPage({ params }: { params: { id: string } }) {
  const lap = await getLap(params.id)
  if (!lap) notFound()

  const tyre   = TYRE_COMPOUNDS[lap.tyre_compound]
  const frames = (lap.telemetry_frames ?? []) as any[]

  const s1Frames = frames.filter(f => f.sector === 0)
  const s2Frames = frames.filter(f => f.sector === 1)
  const s3Frames = frames.filter(f => f.sector === 2)

  const avgSpeed = (arr: any[]) =>
    arr.length ? Math.round(arr.reduce((s, f) => s + f.spd, 0) / arr.length) : null
  const maxSpeed = (arr: any[]) => (arr.length ? Math.max(...arr.map(f => f.spd)) : null)

  const sectors = [
    { label: 'Sector 1', time: lap.sector1_ms, frames: s1Frames },
    { label: 'Sector 2', time: lap.sector2_ms, frames: s2Frames },
    { label: 'Sector 3', time: lap.sector3_ms, frames: s3Frames },
  ]

  const hasWear = lap.tyre_wear_fl != null

  return (
    <div className="space-y-8">
      {/* Breadcrumb */}
      <div>
        <div className="flex items-center gap-2 text-sm text-gray-600 mb-3">
          <Link href="/sessions" className="hover:text-gray-300 transition-colors">Sessions</Link>
          <span>/</span>
          <Link href={`/sessions/${lap.session_id}`} className="hover:text-gray-300 transition-colors">
            {lap.track_name}
          </Link>
          <span>/</span>
          <span className="text-gray-400">Lap {lap.lap_number}</span>
        </div>

        <div className="flex items-end justify-between flex-wrap gap-4">
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-3xl font-mono font-bold">{formatLapTime(lap.lap_time_ms)}</h1>
              {!lap.valid && (
                <span className="text-sm text-red-400 border border-red-900 rounded px-2 py-0.5">
                  Invalid
                </span>
              )}
            </div>
            <div className="flex flex-wrap items-center gap-x-3 mt-2 text-sm text-gray-400">
              <span>{lap.track_name}</span>
              <span className="text-gray-700">·</span>
              <span>Lap {lap.lap_number}</span>
              <span className="text-gray-700">·</span>
              <span>{lap.session_type_name}</span>
              <span className="text-gray-700">·</span>
              <span>AI {lap.ai_difficulty}</span>
              {tyre && (
                <>
                  <span className="text-gray-700">·</span>
                  <span className="flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full" style={{ backgroundColor: tyre.color }} />
                    {tyre.name} — {lap.tyre_age_laps} laps old
                  </span>
                </>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Sector cards */}
      <div className="grid grid-cols-3 gap-4">
        {sectors.map((s, i) => (
          <div key={i} className="bg-gray-900 border border-gray-800 rounded-xl p-5">
            <div className="text-xs text-gray-600 uppercase tracking-widest mb-2">{s.label}</div>
            <div className="text-2xl font-mono font-bold mb-4">{formatSectorTime(s.time)}s</div>
            {s.frames.length > 0 ? (
              <dl className="space-y-1 text-sm">
                <div className="flex justify-between">
                  <dt className="text-gray-500">Avg speed</dt>
                  <dd className="text-white font-medium font-mono">{avgSpeed(s.frames)} km/h</dd>
                </div>
                <div className="flex justify-between">
                  <dt className="text-gray-500">Max speed</dt>
                  <dd className="text-white font-medium font-mono">{maxSpeed(s.frames)} km/h</dd>
                </div>
                <div className="flex justify-between">
                  <dt className="text-gray-500">Avg throttle</dt>
                  <dd className="text-white font-medium font-mono">
                    {Math.round(s.frames.reduce((a, f) => a + f.thr, 0) / s.frames.length * 100)}%
                  </dd>
                </div>
                <div className="flex justify-between">
                  <dt className="text-gray-500">Avg brake</dt>
                  <dd className="text-white font-medium font-mono">
                    {Math.round(s.frames.reduce((a, f) => a + f.brk, 0) / s.frames.length * 100)}%
                  </dd>
                </div>
              </dl>
            ) : (
              <p className="text-xs text-gray-600">No telemetry</p>
            )}
          </div>
        ))}
      </div>

      {/* Telemetry trace */}
      {frames.length > 0 && (
        <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
          <h2 className="text-base font-semibold mb-1">Telemetry Trace</h2>
          <p className="text-xs text-gray-600 mb-5">Speed · Throttle · Brake · DRS vs. lap distance</p>
          <TelemetryChart frames={frames} />
        </div>
      )}

      {/* Tyre wear */}
      {hasWear && (
        <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
          <h2 className="text-base font-semibold mb-1">Tyre Wear at Lap End</h2>
          <p className="text-xs text-gray-600 mb-6">Percentage worn — higher is worse</p>
          <TireWearChart
            fl={lap.tyre_wear_fl}
            fr={lap.tyre_wear_fr}
            rl={lap.tyre_wear_rl}
            rr={lap.tyre_wear_rr}
          />
        </div>
      )}

      {/* ERS */}
      {lap.ers_deployed_this_lap != null && (
        <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
          <h2 className="text-base font-semibold mb-3">Energy Deployment</h2>
          <div className="flex items-center gap-3">
            <div className="text-2xl font-mono font-bold text-blue-400">
              {(lap.ers_deployed_this_lap / 1000).toFixed(1)} kJ
            </div>
            <span className="text-sm text-gray-500">deployed this lap</span>
          </div>
        </div>
      )}
    </div>
  )
}
