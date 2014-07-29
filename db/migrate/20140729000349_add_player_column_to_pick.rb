class AddPlayerColumnToPick < ActiveRecord::Migration
  def change
  		add_column :picks, :player_id, :integer
  end
end
