class FullStatsFifa15bis2 < ActiveRecord::Migration
  def change
  	  	remove_column :players, :reaction, :integer
		add_column :players, :reactions, :integer
  end
end
