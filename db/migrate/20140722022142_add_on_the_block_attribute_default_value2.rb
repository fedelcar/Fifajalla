class AddOnTheBlockAttributeDefaultValue2 < ActiveRecord::Migration
  def change
  	add_column :players, :on_the_block, :boolean, :default => false
  end
end
