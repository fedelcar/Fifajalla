class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :team, index: true
      t.string :first_name
      t.string :last_name
      t.integer :overall
      t.string :primary_position
      t.string :secondary_position
      t.string :tertiary_position
      t.integer :games_played
      t.integer :goals
      t.integer :assists
      t.integer :own_goals
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :pace
      t.integer :shooting
      t.integer :passing
      t.integer :dribbling
      t.integer :defence
      t.integer :heading

      t.timestamps
    end
  end
end
