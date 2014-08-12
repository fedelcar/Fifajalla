class ModelChanges < ActiveRecord::Migration
  def change

  	create_table :picks do |p|
  		p.references :user, index: true
    	p.integer :number
      	p.timestamps
    end

    create_table :event_types do |t|
    	
    	t.string :description
    end

    create_table :events do |e|
    	
    	e.integer :player_id
    	e.integer :match_id
    	e.references :event_type, index: true
    end 


    drop_table :trades

    create_table :trades  do |tr|
    	tr.timestamps
    end

    create_table :player_movements do |pl|
    	pl.references :player, index: true
    	pl.references :trade, index: true
      	pl.timestamps
    end
		
		add_column :player_movements, :first_user_id, :integer
		add_index :player_movements, :first_user_id
		add_column :player_movements, :second_user_id, :integer
		add_index :player_movements, :second_user_id

		add_column :player_movements, :first_team_id, :integer
		add_index :player_movements, :first_team_id
		add_column :player_movements, :second_team_id, :integer
		add_index :player_movements, :second_team_id
    
    drop_table :stats

    add_column :users, :gf, :integer
	add_column :users, :ga, :integer
	add_column :users, :wins, :integer
	add_column :users, :draws, :integer
	add_column :users, :loses, :integer
	add_column :users, :pts, :integer
	add_column :users, :dg, :integer
	add_column :users, :eff, :integer

    
  end
end
