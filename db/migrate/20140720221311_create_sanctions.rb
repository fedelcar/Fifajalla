class CreateSanctions < ActiveRecord::Migration
  def change
    create_table :sanctions do |t|
      t.references :player, index: true
      t.integer :games
      t.timestamps
    end
  end
end
