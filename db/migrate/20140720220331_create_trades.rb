class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.references :player, index: true

      t.timestamps
    end
  end
end
