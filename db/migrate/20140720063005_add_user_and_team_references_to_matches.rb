class AddUserAndTeamReferencesToMatches < ActiveRecord::Migration
	def change
		add_column :matches, :local_user_id, :integer
		add_index :matches, :local_user_id
		add_column :matches, :away_user_id, :integer
		add_index :matches, :away_user_id
	end
end
