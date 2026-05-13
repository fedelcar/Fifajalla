'use client'

interface Props {
  fl: number
  fr: number
  rl: number
  rr: number
}

function wearColor(pct: number): string {
  if (pct < 25) return '#22c55e'
  if (pct < 50) return '#eab308'
  if (pct < 75) return '#f97316'
  return '#ef4444'
}

function TireBar({ value, label }: { value: number; label: string }) {
  const color = wearColor(value)
  const pct   = Math.min(100, Math.max(0, value))

  return (
    <div className="flex flex-col items-center gap-3">
      {/* Vertical bar */}
      <div className="relative w-14 h-36 bg-gray-800 rounded-lg overflow-hidden border border-gray-700">
        <div
          className="absolute bottom-0 w-full rounded-b-lg transition-all duration-500"
          style={{ height: `${pct}%`, backgroundColor: color, opacity: 0.85 }}
        />
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-xs font-mono font-bold text-white drop-shadow-md">
            {value.toFixed(1)}%
          </span>
        </div>
      </div>

      {/* Colour strip mimicking tyre */}
      <div
        className="w-14 h-2 rounded-full"
        style={{ backgroundColor: color, opacity: 0.6 }}
      />
      <span className="text-xs text-gray-400 font-medium">{label}</span>
    </div>
  )
}

export default function TireWearChart({ fl, fr, rl, rr }: Props) {
  return (
    <div className="flex items-end justify-center gap-8">
      <div className="flex flex-col items-center gap-6">
        <span className="text-xs text-gray-600 uppercase tracking-widest">Front</span>
        <div className="flex gap-6">
          <TireBar value={fl} label="FL" />
          <TireBar value={fr} label="FR" />
        </div>
      </div>
      <div className="w-px h-40 bg-gray-800 self-center" />
      <div className="flex flex-col items-center gap-6">
        <span className="text-xs text-gray-600 uppercase tracking-widest">Rear</span>
        <div className="flex gap-6">
          <TireBar value={rl} label="RL" />
          <TireBar value={rr} label="RR" />
        </div>
      </div>
    </div>
  )
}
