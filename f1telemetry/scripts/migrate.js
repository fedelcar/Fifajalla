require('dotenv').config({ path: '.env.local' })
const { Pool } = require('pg')
const fs = require('fs')
const path = require('path')

const pool = new Pool({ connectionString: process.env.DATABASE_URL })

async function migrate() {
  const sql = fs.readFileSync(path.join(__dirname, 'migrate.sql'), 'utf8')
  await pool.query(sql)
  console.log('Migration complete.')
  await pool.end()
}

migrate().catch(err => { console.error(err); process.exit(1) })
