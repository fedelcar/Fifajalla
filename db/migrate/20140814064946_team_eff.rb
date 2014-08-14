class TeamEff < ActiveRecord::Migration
  def change
  	change_column :teams, :eff, :float
  end
end
