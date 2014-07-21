class AddLeagueToPlayers < ActiveRecord::Migration
	def change
		add_column :players, :league, :string
	end
end
