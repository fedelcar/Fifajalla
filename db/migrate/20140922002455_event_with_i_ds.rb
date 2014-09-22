class EventWithIDs < ActiveRecord::Migration
  def change
  	add_column :events, :team_id, :integer
  	add_column :events, :user_id, :integer
  end
end
