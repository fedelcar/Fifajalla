class ModelChangesv2 < ActiveRecord::Migration
  def change
  		add_column :teams, :pts, :integer
		add_column :teams, :dg, :integer
		add_column :teams, :eff, :integer
  end
end
