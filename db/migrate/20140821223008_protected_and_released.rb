class ProtectedAndReleased < ActiveRecord::Migration
  def change
  	add_column :players, :protected, :boolean

  	create_table :releases do |t|
      t.references :player, index: true
      t.references :user, index:true
      t.timestamps
     end
  end
end
