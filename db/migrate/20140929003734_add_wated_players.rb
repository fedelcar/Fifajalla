class AddWatedPlayers < ActiveRecord::Migration
  def change
  	create_table :wantedPlayers do |l|
      l.integer :player_id
      l.integer :user_id
    end
  end
end
