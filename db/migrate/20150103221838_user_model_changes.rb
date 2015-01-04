class UserModelChanges < ActiveRecord::Migration
  def change
  	 add_column :users, :isAdmin, :boolean
  	 remove_column :users, :gf
  	 remove_column :users, :ga
  	 remove_column :users, :wins
  	 remove_column :users, :loses
  	 remove_column :users, :draws
  	 remove_column :users, :pts
  	 remove_column :users, :dg
  	 remove_column :users, :eff
  end
end
