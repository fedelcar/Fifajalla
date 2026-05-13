export function formatLapTime(ms: number | null | undefined): string {
  if (!ms || ms <= 0) return '--:--.---'
  const minutes = Math.floor(ms / 60000)
  const seconds = (ms % 60000) / 1000
  return `${minutes}:${seconds.toFixed(3).padStart(6, '0')}`
}

export function formatSectorTime(ms: number | null | undefined): string {
  if (!ms || ms <= 0) return '--.---'
  return (ms / 1000).toFixed(3)
}

export function formatDate(date: string | Date | null): string {
  if (!date) return ''
  return new Date(date).toLocaleDateString('en-GB', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

export function lapDelta(ms: number, bestMs: number): string {
  const diff = ms - bestMs
  if (diff === 0) return ''
  const sign = diff > 0 ? '+' : '-'
  return `${sign}${(Math.abs(diff) / 1000).toFixed(3)}`
}
