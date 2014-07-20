class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :gf
      t.integer :ga
      t.integer :wins
      t.integer :draws
      t.integer :loses

      t.timestamps
    end
  end
end
