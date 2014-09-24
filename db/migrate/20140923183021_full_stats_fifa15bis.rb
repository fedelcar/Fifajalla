class FullStatsFifa15bis < ActiveRecord::Migration
  def change
  	add_column :players, :stamina, :integer
	add_column :players, :reaction, :integer
  end
end
