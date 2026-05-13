import type { Metadata } from 'next'
import Link from 'next/link'
import './globals.css'

export const metadata: Metadata = {
  title: 'F1 Telemetry',
  description: 'F1 25 lap time and telemetry tracker',
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="bg-gray-950 text-gray-100 min-h-screen antialiased">
        <nav className="border-b border-gray-800 px-6 py-4 sticky top-0 z-50 bg-gray-950/90 backdrop-blur">
          <div className="max-w-7xl mx-auto flex items-center gap-8">
            <Link href="/" className="text-red-500 font-bold text-xl tracking-tight flex items-center gap-2">
              <span>⬡</span>
              <span>F1 Telemetry</span>
            </Link>
            <Link href="/sessions" className="text-gray-400 hover:text-white text-sm transition-colors">
              Sessions
            </Link>
          </div>
        </nav>
        <main className="max-w-7xl mx-auto px-6 py-8">
          {children}
        </main>
      </body>
    </html>
  )
}
