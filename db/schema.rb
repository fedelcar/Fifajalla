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

ActiveRecord::Schema.define(version: 20140725222229) do

  create_table "event_types", force: true do |t|
    t.string "description"
  end

  create_table "events", force: true do |t|
    t.integer "player_id"
    t.integer "match_id"
    t.integer "event_type_id"
  end

  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id"

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
  end

  add_index "matches", ["away_team_id"], name: "index_matches_on_away_team_id"
  add_index "matches", ["away_user_id"], name: "index_matches_on_away_user_id"
  add_index "matches", ["local_team_id"], name: "index_matches_on_local_team_id"
  add_index "matches", ["local_user_id"], name: "index_matches_on_local_user_id"

  create_table "picks", force: true do |t|
    t.integer  "user_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picks", ["user_id"], name: "index_picks_on_user_id"

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

  add_index "player_movements", ["first_team_id"], name: "index_player_movements_on_first_team_id"
  add_index "player_movements", ["first_user_id"], name: "index_player_movements_on_first_user_id"
  add_index "player_movements", ["player_id"], name: "index_player_movements_on_player_id"
  add_index "player_movements", ["second_team_id"], name: "index_player_movements_on_second_team_id"
  add_index "player_movements", ["second_user_id"], name: "index_player_movements_on_second_user_id"
  add_index "player_movements", ["trade_id"], name: "index_player_movements_on_trade_id"

  create_table "players", force: true do |t|
    t.integer  "team_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "overall"
    t.string   "primary_position"
    t.string   "secondary_position"
    t.integer  "games_played"
    t.integer  "goals"
    t.integer  "assists"
    t.integer  "own_goals"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "pace"
    t.integer  "shooting"
    t.integer  "passing"
    t.integer  "dribbling"
    t.integer  "defence"
    t.integer  "heading"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "league"
    t.boolean  "on_the_block"
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id"

  create_table "sanctions", force: true do |t|
    t.integer  "player_id"
    t.integer  "games"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sanctions", ["player_id"], name: "index_sanctions_on_player_id"

  create_table "teams", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
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
    t.integer  "eff"
  end

  add_index "teams", ["user_id"], name: "index_teams_on_user_id"

  create_table "trades", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "gf"
    t.integer  "ga"
    t.integer  "wins"
    t.integer  "draws"
    t.integer  "loses"
    t.integer  "pts"
    t.integer  "dg"
    t.integer  "eff"
  end

end
