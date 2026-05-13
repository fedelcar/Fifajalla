'use client'

import {
  ComposedChart, Line, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, Legend, ResponsiveContainer, Area,
} from 'recharts'

interface Frame {
  d:      number   // distance (m)
  spd:    number   // speed km/h
  thr:    number   // throttle 0–1
  brk:    number   // brake 0–1
  gear:   number
  steer:  number   // -1 to 1
  drs:    number   // 0 or 1
  rpm:    number
  sector: number
}

const CustomTooltip = ({ active, payload, label }: any) => {
  if (!active || !payload?.length) return null
  const byKey = Object.fromEntries(payload.map((p: any) => [p.dataKey, p.value]))
  return (
    <div className="bg-gray-900 border border-gray-700 rounded-lg p-3 text-xs shadow-xl space-y-1 min-w-[140px]">
      <div className="text-gray-500 mb-2">{label} m</div>
      <div className="flex justify-between gap-4">
        <span className="text-amber-400">Speed</span>
        <span className="font-mono text-white">{byKey.speed} km/h</span>
      </div>
      <div className="flex justify-between gap-4">
        <span className="text-green-400">Throttle</span>
        <span className="font-mono text-white">{byKey.throttle}%</span>
      </div>
      <div className="flex justify-between gap-4">
        <span className="text-red-400">Brake</span>
        <span className="font-mono text-white">{byKey.brake}%</span>
      </div>
      <div className="flex justify-between gap-4">
        <span className="text-gray-400">Gear</span>
        <span className="font-mono text-white">{byKey.gear}</span>
      </div>
      {byKey.drs > 0 && (
        <div className="flex justify-between gap-4">
          <span className="text-indigo-400">DRS</span>
          <span className="font-mono text-white">Open</span>
        </div>
      )}
    </div>
  )
}

export default function TelemetryChart({ frames }: { frames: Frame[] }) {
  if (frames.length === 0) return null

  const data = frames.map(f => ({
    d:        Math.round(f.d),
    speed:    f.spd,
    throttle: Math.round(f.thr * 100),
    brake:    Math.round(f.brk * 100),
    gear:     f.gear > 0 ? f.gear : 0,
    drs:      f.drs > 0 ? 30 : 0,  // render as small constant bar when open
  }))

  return (
    <ResponsiveContainer width="100%" height={300}>
      <ComposedChart data={data} margin={{ top: 5, right: 16, left: 4, bottom: 5 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#111827" vertical={false} />
        <XAxis
          dataKey="d"
          tick={{ fill: '#4b5563', fontSize: 10 }}
          axisLine={{ stroke: '#1f2937' }}
          tickLine={false}
          label={{ value: 'Distance (m)', position: 'insideBottomRight', offset: -8, fill: '#4b5563', fontSize: 10 }}
        />
        {/* Left axis — speed */}
        <YAxis
          yAxisId="speed"
          domain={[0, 380]}
          tick={{ fill: '#4b5563', fontSize: 10 }}
          axisLine={false}
          tickLine={false}
          label={{ value: 'km/h', angle: -90, position: 'insideLeft', offset: 10, fill: '#4b5563', fontSize: 10 }}
          width={40}
        />
        {/* Right axis — % */}
        <YAxis
          yAxisId="pct"
          orientation="right"
          domain={[0, 100]}
          tick={{ fill: '#4b5563', fontSize: 10 }}
          axisLine={false}
          tickLine={false}
          tickFormatter={v => `${v}%`}
          width={36}
        />
        <Tooltip content={<CustomTooltip />} cursor={{ stroke: '#374151', strokeWidth: 1 }} />
        <Legend
          wrapperStyle={{ color: '#9ca3af', fontSize: 11, paddingTop: 8 }}
          formatter={(value) => value.charAt(0).toUpperCase() + value.slice(1)}
        />

        {/* DRS as subtle background bars */}
        <Bar yAxisId="pct" dataKey="drs" fill="#6366f1" opacity={0.25} name="drs" legendType="none" />

        {/* Speed line */}
        <Line
          yAxisId="speed"
          type="monotone"
          dataKey="speed"
          stroke="#f59e0b"
          strokeWidth={2}
          dot={false}
          name="speed"
          activeDot={{ r: 3, fill: '#f59e0b' }}
        />
        {/* Throttle */}
        <Area
          yAxisId="pct"
          type="monotone"
          dataKey="throttle"
          stroke="#22c55e"
          fill="#22c55e"
          fillOpacity={0.08}
          strokeWidth={1.5}
          dot={false}
          name="throttle"
        />
        {/* Brake */}
        <Area
          yAxisId="pct"
          type="monotone"
          dataKey="brake"
          stroke="#ef4444"
          fill="#ef4444"
          fillOpacity={0.08}
          strokeWidth={1.5}
          dot={false}
          name="brake"
        />
      </ComposedChart>
    </ResponsiveContainer>
  )
}
