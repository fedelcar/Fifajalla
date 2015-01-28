class AddImageUrl < ActiveRecord::Migration
  def change
  	add_column :users, :imageURL, :string
  	add_column :teams, :imageURL, :string
  	add_column :players, :imageURL, :string
  end
end
