class DraftIdAndTable < ActiveRecord::Migration
  def change
  	create_table :drafts do |d|
      d.string :name
      d.integer :users
      d.integer :rounds
      d.timestamps
    end

  	add_column :picks, :draft_id, :integer
  
  end
end
