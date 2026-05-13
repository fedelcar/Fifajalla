class DeleteRealPlayers < ActiveRecord::Migration[4.2]
  def change
    drop_table :realPlayers
  end
end
