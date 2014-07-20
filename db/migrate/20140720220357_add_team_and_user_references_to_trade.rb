class AddTeamAndUserReferencesToTrade < ActiveRecord::Migration
	def change
		add_column :trades, :first_user_id, :integer
		add_index :trades, :first_user_id
		add_column :trades, :second_user_id, :integer
		add_index :trades, :second_user_id

		add_column :trades, :first_team_id, :integer
		add_index :trades, :first_team_id
		add_column :trades, :second_team_id, :integer
		add_index :trades, :second_team_id
	end
end
