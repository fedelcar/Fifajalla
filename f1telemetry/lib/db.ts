import { Pool } from 'pg'

const globalForPg = globalThis as unknown as { pool?: Pool }

const pool =
  globalForPg.pool ??
  new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl:
      process.env.DATABASE_URL?.includes('neon.tech') ||
      process.env.DATABASE_URL?.includes('sslmode=require')
        ? { rejectUnauthorized: false }
        : false,
  })

if (process.env.NODE_ENV !== 'production') globalForPg.pool = pool

export default pool
