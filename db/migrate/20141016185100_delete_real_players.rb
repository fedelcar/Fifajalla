class DeleteRealPlayers < ActiveRecord::Migration
  def change
    drop_table :realPlayers
  end
end
