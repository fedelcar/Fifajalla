class AddForeignKeyToStats < ActiveRecord::Migration
	def change
		add_foreign_key(:stats, :users)
	end
end
