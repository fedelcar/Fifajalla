class AddOnTheBlockAttributeDefaultValue < ActiveRecord::Migration
  def change
  	  	remove_column :players, :on_the_block
  end
end
