class AddRealTeamsAndPlayers < ActiveRecord::Migration
  def change
    create_table :realTeams do |l|
      l.string :name
      l.string :league
      l.timestamps
    end

    create_table :realPlayers do |l|
      l.integer :player_id
      l.integer :real_team_id
    end


  end
end
