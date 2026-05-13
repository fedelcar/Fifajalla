class AddImageUrl < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :imageURL, :string
  	add_column :teams, :imageURL, :string
  	add_column :players, :imageURL, :string
  end
end
