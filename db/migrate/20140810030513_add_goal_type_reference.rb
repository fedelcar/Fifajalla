class AddGoalTypeReference < ActiveRecord::Migration
  def change
  		add_column :events, :goal_type_id, :integer
  end
end
