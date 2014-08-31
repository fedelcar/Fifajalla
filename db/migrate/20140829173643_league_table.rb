class LeagueTable < ActiveRecord::Migration
  def change
  	create_table :leagues do |l|
      l.string :name
      l.integer :importance
      l.integer :round1_matches
      l.timestamps
    end
  end
end
