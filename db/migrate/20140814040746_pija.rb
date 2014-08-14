class Pija < ActiveRecord::Migration
  def change

  	change_column :users, :eff, :float


  end
end
