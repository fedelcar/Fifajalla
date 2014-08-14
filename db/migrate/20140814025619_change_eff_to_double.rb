class ChangeEffToDouble < ActiveRecord::Migration
  def change
  	change_column :users, :eff, :double
  end
end
