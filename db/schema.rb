# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_05_13_174607) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drafts", id: :serial, force: :cascade do |t|
    t.text "name"
    t.integer "users"
    t.integer "rounds"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.text "description"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "match_id"
    t.integer "event_type_id"
    t.integer "goal_type_id"
    t.integer "team_id"
    t.integer "user_id"
  end

  create_table "goal_types", id: :serial, force: :cascade do |t|
    t.text "description"
  end

  create_table "leagues", id: :serial, force: :cascade do |t|
    t.text "name"
    t.integer "importance"
    t.integer "round1_matches"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "finished"
    t.integer "champion_id"
  end

  create_table "matches", id: :serial, force: :cascade do |t|
    t.integer "local_goals"
    t.integer "away_goals"
    t.date "date"
    t.time "time"
    t.boolean "elimination"
    t.boolean "golden_goal"
    t.integer "local_penalties"
    t.integer "away_penalties"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "local_user_id"
    t.integer "away_user_id"
    t.integer "local_team_id"
    t.integer "away_team_id"
    t.boolean "finished"
    t.integer "league_id"
    t.index ["away_team_id"], name: "index_matches_on_away_team_id"
    t.index ["away_user_id"], name: "index_matches_on_away_user_id"
    t.index ["local_team_id"], name: "index_matches_on_local_team_id"
    t.index ["local_user_id"], name: "index_matches_on_local_user_id"
  end

  create_table "picks", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "number"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "player_id"
    t.integer "draft_id"
    t.index ["user_id"], name: "index_picks_on_user_id"
  end

  create_table "player_movements", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "trade_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "first_user_id"
    t.integer "second_user_id"
    t.integer "first_team_id"
    t.integer "second_team_id"
    t.index ["first_team_id"], name: "index_player_movements_on_first_team_id"
    t.index ["first_user_id"], name: "index_player_movements_on_first_user_id"
    t.index ["player_id"], name: "index_player_movements_on_player_id"
    t.index ["second_team_id"], name: "index_player_movements_on_second_team_id"
    t.index ["second_user_id"], name: "index_player_movements_on_second_user_id"
    t.index ["trade_id"], name: "index_player_movements_on_trade_id"
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.text "first_name"
    t.text "last_name"
    t.integer "overall"
    t.text "primary_position"
    t.text "secondary_position"
    t.integer "games_played"
    t.integer "goals"
    t.integer "assists"
    t.integer "own_goals"
    t.integer "yellow_cards"
    t.integer "red_cards"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "league"
    t.boolean "on_the_block"
    t.integer "user_id"
    t.boolean "protected"
    t.text "club"
    t.integer "age"
    t.text "height"
    t.text "attack_WR"
    t.text "defend_WR"
    t.integer "weak_foot"
    t.integer "skill_moves"
    t.boolean "starting"
    t.integer "acceleration"
    t.integer "sprint_speed"
    t.integer "ball_control"
    t.integer "dribbling_skill"
    t.integer "agility"
    t.integer "balance"
    t.integer "curve"
    t.integer "finishing"
    t.integer "free_kick_accuracy"
    t.integer "long_shots"
    t.integer "penalties"
    t.integer "shot_power"
    t.integer "volleys"
    t.integer "vision"
    t.integer "crossing"
    t.integer "long_passing"
    t.integer "short_passing"
    t.integer "heading_accuracy"
    t.integer "jumping"
    t.integer "strength"
    t.integer "sliding_tackle"
    t.integer "marking"
    t.integer "standing_tackle"
    t.integer "aggression"
    t.integer "interceptions"
    t.integer "diving"
    t.integer "handling"
    t.integer "kicking"
    t.integer "positioning"
    t.integer "reflexes"
    t.integer "stamina"
    t.integer "reactions"
    t.text "nation"
    t.string "imageURL"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "realPlayers", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "real_team_id"
  end

  create_table "realTeams", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "league"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "releases", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "user_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["player_id"], name: "index_releases_on_player_id"
    t.index ["user_id"], name: "index_releases_on_user_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "name"
    t.boolean "country"
    t.integer "wins"
    t.integer "loses"
    t.integer "draws"
    t.integer "gf"
    t.integer "ga"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "pts"
    t.integer "dg"
    t.float "eff"
    t.string "imageURL"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "trade_approvals", id: :serial, force: :cascade do |t|
    t.integer "trade_id"
    t.integer "user_id"
    t.boolean "approved"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["trade_id"], name: "index_trade_approvals_on_trade_id"
    t.index ["user_id"], name: "index_trade_approvals_on_user_id"
  end

  create_table "trades", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "status"
    t.integer "users"
    t.integer "approvals"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "email"
    t.integer "gf"
    t.integer "ga"
    t.integer "wins"
    t.integer "draws"
    t.integer "loses"
    t.integer "pts"
    t.integer "dg"
    t.float "eff"
    t.text "provider"
    t.text "uid"
    t.text "oauth_token"
    t.datetime "oauth_expires_at", precision: nil
    t.text "display_name"
    t.integer "elo"
    t.integer "minutes"
    t.boolean "isAdmin"
    t.string "imageURL"
  end

  create_table "wanted_players", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "user_id"
  end

end
