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

ActiveRecord::Schema.define(version: 20140721010517) do

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
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id"

  create_table "sanctions", force: true do |t|
    t.integer  "player_id"
    t.integer  "games"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sanctions", ["player_id"], name: "index_sanctions_on_player_id"

  create_table "stats", force: true do |t|
    t.integer  "gf"
    t.integer  "ga"
    t.integer  "wins"
    t.integer  "draws"
    t.integer  "loses"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

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
  end

  add_index "teams", ["user_id"], name: "index_teams_on_user_id"

  create_table "trades", force: true do |t|
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "first_user_id"
    t.integer  "second_user_id"
    t.integer  "first_team_id"
    t.integer  "second_team_id"
  end

  add_index "trades", ["first_team_id"], name: "index_trades_on_first_team_id"
  add_index "trades", ["first_user_id"], name: "index_trades_on_first_user_id"
  add_index "trades", ["player_id"], name: "index_trades_on_player_id"
  add_index "trades", ["second_team_id"], name: "index_trades_on_second_team_id"
  add_index "trades", ["second_user_id"], name: "index_trades_on_second_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
