'use client'

import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  Cell, ReferenceLine, ResponsiveContainer,
} from 'recharts'
import { formatLapTime } from '@/lib/utils'

interface Lap {
  id: number
  lap_number: number
  lap_time_ms: number
  valid: boolean
}

const CustomTooltip = ({ active, payload }: any) => {
  if (!active || !payload?.length) return null
  const lap = payload[0].payload
  return (
    <div className="bg-gray-800 border border-gray-700 rounded-lg p-3 text-sm shadow-xl">
      <div className="text-gray-400 text-xs mb-1">Lap {lap.lap_number}</div>
      <div className="font-mono font-bold text-white">{formatLapTime(lap.lap_time_ms)}</div>
      {!lap.valid && <div className="text-red-400 text-xs mt-1">Invalid</div>}
    </div>
  )
}

export default function LapTimeChart({ laps }: { laps: Lap[] }) {
  if (laps.length === 0) return null

  const validTimes = laps.filter(l => l.valid && l.lap_time_ms > 0).map(l => l.lap_time_ms)
  const minTime    = Math.min(...validTimes)
  const maxTime    = Math.max(...validTimes)
  const pad        = Math.max(1000, (maxTime - minTime) * 0.3)
  const yMin       = Math.max(0, minTime - pad)
  const yMax       = maxTime + pad * 0.5

  return (
    <ResponsiveContainer width="100%" height={220}>
      <BarChart data={laps} margin={{ top: 24, right: 8, left: 4, bottom: 4 }} barCategoryGap="30%">
        <CartesianGrid strokeDasharray="3 3" stroke="#1f2937" vertical={false} />
        <XAxis
          dataKey="lap_number"
          tick={{ fill: '#6b7280', fontSize: 11 }}
          axisLine={{ stroke: '#374151' }}
          tickLine={false}
          label={{ value: 'Lap', position: 'insideBottom', offset: -2, fill: '#4b5563', fontSize: 11 }}
        />
        <YAxis
          domain={[yMin, yMax]}
          tick={{ fill: '#6b7280', fontSize: 11 }}
          axisLine={false}
          tickLine={false}
          tickFormatter={formatLapTime}
          width={78}
        />
        <Tooltip content={<CustomTooltip />} cursor={{ fill: 'rgba(255,255,255,0.03)' }} />
        <ReferenceLine y={minTime} stroke="#22c55e" strokeDasharray="4 3" strokeWidth={1} />
        <Bar dataKey="lap_time_ms" radius={[3, 3, 0, 0]} label={{ position: 'top', fill: '#9ca3af', fontSize: 10, formatter: formatLapTime }}>
          {laps.map((lap) => (
            <Cell
              key={lap.id}
              fill={
                lap.lap_time_ms === minTime
                  ? '#22c55e'
                  : !lap.valid
                  ? '#ef4444'
                  : '#6366f1'
              }
              fillOpacity={0.8}
            />
          ))}
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  )
}
