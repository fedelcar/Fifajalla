class ModelChangesv2 < ActiveRecord::Migration
  def change
  	User.create(name: "N/A", id: 1, gf:0, ga:0, wins:0, draws:0, loses:0, dg:0, pts:0, eff:0)
  	Team.create(name: "FA", id:1, gf:0, ga:0, wins:0, draws:0, loses:0)
	
  		add_column :teams, :pts, :integer
		add_column :teams, :dg, :integer
		add_column :teams, :eff, :integer
  end
end
