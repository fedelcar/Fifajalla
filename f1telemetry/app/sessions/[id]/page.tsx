import Link from 'next/link'
import { notFound } from 'next/navigation'
import pool from '@/lib/db'
import { formatLapTime, formatSectorTime, formatDate, lapDelta } from '@/lib/utils'
import { TYRE_COMPOUNDS, WEATHER } from '@/lib/constants'
import LapTimeChart from '@/components/LapTimeChart'

export const dynamic = 'force-dynamic'

async function getSession(id: string) {
  const [sessionRes, lapsRes] = await Promise.all([
    pool.query('SELECT * FROM race_sessions WHERE id = $1', [id]),
    pool.query('SELECT * FROM laps WHERE race_session_id = $1 ORDER BY car_index, lap_number', [id]),
  ])
  if (sessionRes.rows.length === 0) return null
  return { session: sessionRes.rows[0], laps: lapsRes.rows }
}

export default async function SessionPage({ params }: { params: { id: string } }) {
  const data = await getSession(params.id)
  if (!data) notFound()

  const { session, laps } = data
  const playerLaps = laps
    .filter((l: any) => l.is_player && l.lap_time_ms > 0)
    .sort((a: any, b: any) => a.lap_number - b.lap_number)

  const bestLap = playerLaps
    .filter((l: any) => l.valid)
    .sort((a: any, b: any) => a.lap_time_ms - b.lap_time_ms)[0] ?? null

  // Best sector times (each sector independently)
  const bestS1 = Math.min(...playerLaps.filter((l: any) => l.sector1_ms > 0).map((l: any) => l.sector1_ms))
  const bestS2 = Math.min(...playerLaps.filter((l: any) => l.sector2_ms > 0).map((l: any) => l.sector2_ms))
  const bestS3 = Math.min(...playerLaps.filter((l: any) => l.sector3_ms > 0).map((l: any) => l.sector3_ms))

  // Other cars grouped by car_index
  const otherCars = Object.values(
    laps
      .filter((l: any) => !l.is_player && l.lap_time_ms > 0)
      .reduce((acc: any, l: any) => {
        if (!acc[l.car_index]) acc[l.car_index] = { name: l.driver_name, team: l.team_name, laps: [] }
        acc[l.car_index].laps.push(l)
        return acc
      }, {}),
  ).map((d: any) => ({
    ...d,
    best: d.laps.sort((a: any, b: any) => a.lap_time_ms - b.lap_time_ms)[0],
    count: d.laps.length,
  })).sort((a: any, b: any) => a.best.lap_time_ms - b.best.lap_time_ms)

  return (
    <div className="space-y-8">
      {/* Breadcrumb + header */}
      <div>
        <div className="flex items-center gap-2 text-sm text-gray-600 mb-3">
          <Link href="/sessions" className="hover:text-gray-300 transition-colors">Sessions</Link>
          <span>/</span>
          <span className="text-gray-400">{session.track_name}</span>
        </div>
        <div className="flex items-end justify-between flex-wrap gap-4">
          <div>
            <h1 className="text-3xl font-bold">{session.track_name}</h1>
            <div className="flex flex-wrap items-center gap-x-3 gap-y-1 mt-2 text-sm text-gray-400">
              <span>{session.session_type_name}</span>
              <span className="text-gray-700">·</span>
              <span>AI <span className="text-white font-medium">{session.ai_difficulty}</span></span>
              <span className="text-gray-700">·</span>
              <span>{WEATHER[session.weather] ?? '—'}</span>
              <span className="text-gray-700">·</span>
              <span>{formatDate(session.started_at)}</span>
            </div>
          </div>
          {bestLap && (
            <div className="text-right">
              <div className="text-xs text-gray-600 mb-1 uppercase tracking-wide">Best Lap</div>
              <div className="text-2xl font-mono font-bold text-green-400">
                {formatLapTime(bestLap.lap_time_ms)}
              </div>
              <div className="text-xs text-gray-500 mt-0.5">Lap {bestLap.lap_number}</div>
            </div>
          )}
        </div>
      </div>

      {/* Lap time chart */}
      {playerLaps.length > 1 && (
        <div className="bg-gray-900 border border-gray-800 rounded-xl p-6">
          <h2 className="text-base font-semibold mb-4 text-gray-300">Lap Times</h2>
          <LapTimeChart laps={playerLaps} />
        </div>
      )}

      {/* Player laps table */}
      {playerLaps.length > 0 && (
        <div className="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-800">
            <h2 className="text-base font-semibold">Your Laps</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="text-gray-500 text-xs uppercase tracking-wide border-b border-gray-800">
                  <th className="px-4 py-3 text-left w-12">Lap</th>
                  <th className="px-4 py-3 text-left">Time</th>
                  <th className="px-4 py-3 text-left">Delta</th>
                  <th className="px-4 py-3 text-left">S1</th>
                  <th className="px-4 py-3 text-left">S2</th>
                  <th className="px-4 py-3 text-left">S3</th>
                  <th className="px-4 py-3 text-left">Tyre</th>
                  <th className="px-4 py-3 text-left">Age</th>
                  <th className="px-4 py-3 text-left">Wear FL·FR</th>
                  <th className="px-4 py-3 text-left">Wear RL·RR</th>
                  <th className="px-4 py-3 text-left"></th>
                </tr>
              </thead>
              <tbody>
                {playerLaps.map((lap: any) => {
                  const tyre   = TYRE_COMPOUNDS[lap.tyre_compound]
                  const isBest = bestLap?.id === lap.id
                  const delta  = bestLap && !isBest ? lapDelta(lap.lap_time_ms, bestLap.lap_time_ms) : ''
                  return (
                    <tr
                      key={lap.id}
                      className={`border-b border-gray-800/40 hover:bg-gray-800/20 transition-colors
                        ${!lap.valid ? 'opacity-40' : ''}`}
                    >
                      <td className="px-4 py-3 text-gray-400 font-medium">{lap.lap_number}</td>
                      <td className="px-4 py-3 font-mono font-semibold">
                        <span className={isBest ? 'text-green-400' : 'text-white'}>
                          {isBest && <span className="text-green-500 mr-1 text-xs">★</span>}
                          {formatLapTime(lap.lap_time_ms)}
                        </span>
                        {!lap.valid && <span className="text-red-500 text-xs ml-1.5">inv</span>}
                      </td>
                      <td className="px-4 py-3 font-mono text-xs text-yellow-400">{delta}</td>
                      <td className={`px-4 py-3 font-mono text-xs ${lap.sector1_ms === bestS1 ? 'text-purple-400' : 'text-gray-400'}`}>
                        {formatSectorTime(lap.sector1_ms)}
                      </td>
                      <td className={`px-4 py-3 font-mono text-xs ${lap.sector2_ms === bestS2 ? 'text-purple-400' : 'text-gray-400'}`}>
                        {formatSectorTime(lap.sector2_ms)}
                      </td>
                      <td className={`px-4 py-3 font-mono text-xs ${lap.sector3_ms === bestS3 ? 'text-purple-400' : 'text-gray-400'}`}>
                        {formatSectorTime(lap.sector3_ms)}
                      </td>
                      <td className="px-4 py-3">
                        {tyre && (
                          <span className="flex items-center gap-1.5 text-xs">
                            <span className="w-2 h-2 rounded-full flex-shrink-0" style={{ backgroundColor: tyre.color }} />
                            <span className="text-gray-300">{tyre.name}</span>
                          </span>
                        )}
                      </td>
                      <td className="px-4 py-3 text-gray-500 text-xs">{lap.tyre_age_laps ?? '—'}</td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-500">
                        {lap.tyre_wear_fl != null
                          ? `${lap.tyre_wear_fl.toFixed(1)}·${lap.tyre_wear_fr.toFixed(1)}%`
                          : '—'}
                      </td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-500">
                        {lap.tyre_wear_rl != null
                          ? `${lap.tyre_wear_rl.toFixed(1)}·${lap.tyre_wear_rr.toFixed(1)}%`
                          : '—'}
                      </td>
                      <td className="px-4 py-3">
                        {lap.telemetry_frames && (
                          <Link
                            href={`/laps/${lap.id}`}
                            className="text-xs text-blue-400 hover:text-blue-300 transition-colors whitespace-nowrap"
                          >
                            Telemetry →
                          </Link>
                        )}
                      </td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* All cars best laps */}
      {(otherCars as any[]).length > 0 && (
        <div className="bg-gray-900 border border-gray-800 rounded-xl overflow-hidden">
          <div className="px-6 py-4 border-b border-gray-800">
            <h2 className="text-base font-semibold">All Cars — Best Laps</h2>
          </div>
          <table className="w-full text-sm">
            <thead>
              <tr className="text-gray-500 text-xs uppercase tracking-wide border-b border-gray-800">
                <th className="px-6 py-3 text-left">P</th>
                <th className="px-6 py-3 text-left">Driver</th>
                <th className="px-6 py-3 text-left">Team</th>
                <th className="px-6 py-3 text-left">Best Lap</th>
                <th className="px-6 py-3 text-left">S1</th>
                <th className="px-6 py-3 text-left">S2</th>
                <th className="px-6 py-3 text-left">S3</th>
                <th className="px-6 py-3 text-left">Laps</th>
              </tr>
            </thead>
            <tbody>
              {(otherCars as any[]).map((d: any, i: number) => (
                <tr key={i} className="border-b border-gray-800/40">
                  <td className="px-6 py-3 text-gray-500 text-xs">P{i + 1}</td>
                  <td className="px-6 py-3 font-medium">{d.name}</td>
                  <td className="px-6 py-3 text-gray-400">{d.team}</td>
                  <td className="px-6 py-3 font-mono">{formatLapTime(d.best.lap_time_ms)}</td>
                  <td className="px-6 py-3 font-mono text-xs text-gray-500">{formatSectorTime(d.best.sector1_ms)}</td>
                  <td className="px-6 py-3 font-mono text-xs text-gray-500">{formatSectorTime(d.best.sector2_ms)}</td>
                  <td className="px-6 py-3 font-mono text-xs text-gray-500">{formatSectorTime(d.best.sector3_ms)}</td>
                  <td className="px-6 py-3 text-gray-500">{d.count}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
