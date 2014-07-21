class RemoveTertiaryPositionFromPlayers < ActiveRecord::Migration
	def change
		remove_column :players, :tertiary_position
	end
end
