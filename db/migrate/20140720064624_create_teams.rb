class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :user, index: true
      t.string :name
      t.boolean :country
      t.integer :wins
      t.integer :loses
      t.integer :draws
      t.integer :gf
      t.integer :ga

      t.timestamps
    end
  end
end
