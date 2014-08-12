class AddFinishedMatch < ActiveRecord::Migration
  def change
  		add_column :matches, :finished, :boolean
  end
end
