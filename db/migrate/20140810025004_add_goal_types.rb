class AddGoalTypes < ActiveRecord::Migration
  def change
    create_table :goal_types do |t|
    	t.integer :description
    	t.timestamps
    end
  end
end
