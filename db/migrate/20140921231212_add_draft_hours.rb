class AddDraftHours < ActiveRecord::Migration
  def change
  	add_column :users, :minutes, :integer
  end
end
