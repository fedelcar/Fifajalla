class AddElo < ActiveRecord::Migration
  def change
  	add_column :users, :elo, :integer
  end
end
