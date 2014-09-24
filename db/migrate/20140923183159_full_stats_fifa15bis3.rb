class FullStatsFifa15bis3 < ActiveRecord::Migration
  def change
  	remove_column :players, :nationality
	add_column :players, :nation, :string
  end
end
