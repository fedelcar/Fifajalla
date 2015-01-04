# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150103221838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drafts", force: true do |t|
    t.text     "name"
    t.integer  "users"
    t.integer  "rounds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", force: true do |t|
    t.text "description"
  end

  create_table "events", force: true do |t|
    t.integer "player_id"
    t.integer "match_id"
    t.integer "event_type_id"
    t.integer "goal_type_id"
    t.integer "team_id"
    t.integer "user_id"
  end

  create_table "goal_types", force: true do |t|
    t.text "description"
  end

  create_table "leagues", force: true do |t|
    t.text     "name"
    t.integer  "importance"
    t.integer  "round1_matches"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finished"
    t.integer  "champion_id"
  end

  create_table "matches", force: true do |t|
    t.integer  "local_goals"
    t.integer  "away_goals"
    t.date     "date"
    t.time     "time"
    t.boolean  "elimination"
    t.boolean  "golden_goal"
    t.integer  "local_penalties"
    t.integer  "away_penalties"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_user_id"
    t.integer  "away_user_id"
    t.integer  "local_team_id"
    t.integer  "away_team_id"
    t.boolean  "finished"
    t.integer  "league_id"
  end

  add_index "matches", ["away_team_id"], name: "index_matches_on_away_team_id", using: :btree
  add_index "matches", ["away_user_id"], name: "index_matches_on_away_user_id", using: :btree
  add_index "matches", ["local_team_id"], name: "index_matches_on_local_team_id", using: :btree
  add_index "matches", ["local_user_id"], name: "index_matches_on_local_user_id", using: :btree

  create_table "picks", force: true do |t|
    t.integer  "user_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
    t.integer  "draft_id"
  end

  add_index "picks", ["user_id"], name: "index_picks_on_user_id", using: :btree

  create_table "player_movements", force: true do |t|
    t.integer  "player_id"
    t.integer  "trade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "first_user_id"
    t.integer  "second_user_id"
    t.integer  "first_team_id"
    t.integer  "second_team_id"
  end

  add_index "player_movements", ["first_team_id"], name: "index_player_movements_on_first_team_id", using: :btree
  add_index "player_movements", ["first_user_id"], name: "index_player_movements_on_first_user_id", using: :btree
  add_index "player_movements", ["player_id"], name: "index_player_movements_on_player_id", using: :btree
  add_index "player_movements", ["second_team_id"], name: "index_player_movements_on_second_team_id", using: :btree
  add_index "player_movements", ["second_user_id"], name: "index_player_movements_on_second_user_id", using: :btree
  add_index "player_movements", ["trade_id"], name: "index_player_movements_on_trade_id", using: :btree

  create_table "players", force: true do |t|
    t.integer  "team_id"
    t.text     "first_name"
    t.text     "last_name"
    t.integer  "overall"
    t.text     "primary_position"
    t.text     "secondary_position"
    t.integer  "games_played"
    t.integer  "goals"
    t.integer  "assists"
    t.integer  "own_goals"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "league"
    t.boolean  "on_the_block"
    t.integer  "user_id"
    t.boolean  "protected"
    t.text     "club"
    t.integer  "age"
    t.text     "height"
    t.text     "attack_WR"
    t.text     "defend_WR"
    t.integer  "weak_foot"
    t.integer  "skill_moves"
    t.boolean  "starting"
    t.integer  "acceleration"
    t.integer  "sprint_speed"
    t.integer  "ball_control"
    t.integer  "dribbling_skill"
    t.integer  "agility"
    t.integer  "balance"
    t.integer  "curve"
    t.integer  "finishing"
    t.integer  "free_kick_accuracy"
    t.integer  "long_shots"
    t.integer  "penalties"
    t.integer  "shot_power"
    t.integer  "volleys"
    t.integer  "vision"
    t.integer  "crossing"
    t.integer  "long_passing"
    t.integer  "short_passing"
    t.integer  "heading_accuracy"
    t.integer  "jumping"
    t.integer  "strength"
    t.integer  "sliding_tackle"
    t.integer  "marking"
    t.integer  "standing_tackle"
    t.integer  "aggression"
    t.integer  "interceptions"
    t.integer  "diving"
    t.integer  "handling"
    t.integer  "kicking"
    t.integer  "positioning"
    t.integer  "reflexes"
    t.integer  "stamina"
    t.integer  "reactions"
    t.text     "nation"
    t.integer  "real_team_id"
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "realTeams", force: true do |t|
    t.text     "name"
    t.text     "league"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "releases", force: true do |t|
    t.integer  "player_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "releases", ["player_id"], name: "index_releases_on_player_id", using: :btree
  add_index "releases", ["user_id"], name: "index_releases_on_user_id", using: :btree

  create_table "teams", force: true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.boolean  "country"
    t.integer  "wins"
    t.integer  "loses"
    t.integer  "draws"
    t.integer  "gf"
    t.integer  "ga"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pts"
    t.integer  "dg"
    t.float    "eff"
  end

  add_index "teams", ["user_id"], name: "index_teams_on_user_id", using: :btree

  create_table "trade_approvals", force: true do |t|
    t.integer  "trade_id"
    t.integer  "user_id"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trade_approvals", ["trade_id"], name: "index_trade_approvals_on_trade_id", using: :btree
  add_index "trade_approvals", ["user_id"], name: "index_trade_approvals_on_user_id", using: :btree

  create_table "trades", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "status"
    t.integer  "users"
    t.integer  "approvals"
  end

  create_table "users", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "email"
    t.text     "provider"
    t.text     "uid"
    t.text     "oauth_token"
    t.datetime "oauth_expires_at"
    t.text     "display_name"
    t.integer  "elo"
    t.integer  "minutes"
    t.boolean  "isAdmin"
  end

  create_table "wanted_players", force: true do |t|
    t.integer "player_id"
    t.integer "user_id"
  end

end
