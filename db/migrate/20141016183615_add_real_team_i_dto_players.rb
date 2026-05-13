class AddRealTeamIDtoPlayers < ActiveRecord::Migration[4.2]
  def change
     add_column :players, :real_team_id, :integer
  end
end
