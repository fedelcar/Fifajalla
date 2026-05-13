CREATE TABLE IF NOT EXISTS race_sessions (
  id          SERIAL PRIMARY KEY,
  session_uid VARCHAR(20) UNIQUE NOT NULL,
  track_id    INTEGER,
  track_name  VARCHAR(100),
  session_type      INTEGER,
  session_type_name VARCHAR(50),
  weather      INTEGER,
  ai_difficulty INTEGER,
  total_laps   INTEGER,
  game_year    INTEGER,
  track_length INTEGER,
  started_at   TIMESTAMPTZ DEFAULT NOW(),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS laps (
  id               SERIAL PRIMARY KEY,
  race_session_id  INTEGER REFERENCES race_sessions(id) ON DELETE CASCADE,
  car_index        INTEGER NOT NULL,
  driver_name      VARCHAR(100),
  team_id          INTEGER,
  team_name        VARCHAR(100),
  lap_number       INTEGER NOT NULL,
  lap_time_ms      INTEGER,
  sector1_ms       INTEGER,
  sector2_ms       INTEGER,
  sector3_ms       INTEGER,
  valid            BOOLEAN DEFAULT TRUE,
  tyre_compound    INTEGER,
  tyre_age_laps    INTEGER,
  car_position     INTEGER,
  is_player        BOOLEAN DEFAULT FALSE,
  tyre_wear_fl     FLOAT,
  tyre_wear_fr     FLOAT,
  tyre_wear_rl     FLOAT,
  tyre_wear_rr     FLOAT,
  ers_deployed_this_lap FLOAT,
  -- Downsampled telemetry frames stored as JSON array (player laps only)
  -- Each frame: {d, spd, thr, brk, gear, steer, drs, rpm, sector}
  telemetry_frames JSONB,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_laps_session    ON laps(race_session_id);
CREATE INDEX IF NOT EXISTS idx_laps_player     ON laps(race_session_id, is_player);
CREATE INDEX IF NOT EXISTS idx_laps_best       ON laps(race_session_id, lap_time_ms) WHERE is_player AND valid AND lap_time_ms IS NOT NULL;
