class AddUserIdToPlayer2 < ActiveRecord::Migration
  def change
  	remove_column :users, :user_id
  	add_column :players, :user_id, :integer
  end
end
