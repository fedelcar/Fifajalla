class AddRealTeamIDtoPlayers < ActiveRecord::Migration
  def change
     add_column :players, :real_team_id, :integer
  end
end
