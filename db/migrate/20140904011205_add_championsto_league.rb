class AddChampionstoLeague < ActiveRecord::Migration
  def change
  	add_column :leagues, :champion_id, :integer
  end
end
