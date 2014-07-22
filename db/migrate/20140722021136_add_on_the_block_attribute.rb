class AddOnTheBlockAttribute < ActiveRecord::Migration
  def change
  	add_column :players, :on_the_block, :boolean

  end
end
