class AddFinishedLeague < ActiveRecord::Migration
  def change
  		add_column :leagues, :finished, :boolean
  end
end
