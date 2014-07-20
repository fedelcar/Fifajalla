class AddTeamReferencesToMatch < ActiveRecord::Migration
	def change
		add_column :matches, :local_team_id, :integer
		add_index :matches, :local_team_id
		add_column :matches, :away_team_id, :integer
		add_index :matches, :away_team_id
	end
end
