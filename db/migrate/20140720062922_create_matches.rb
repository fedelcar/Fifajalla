class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :local_goals
      t.integer :away_goals
      t.date :date
      t.time :time
      t.boolean :elimination
      t.boolean :golden_goal
      t.integer :local_penalties
      t.integer :away_penalties

      t.timestamps
    end
  end
end
