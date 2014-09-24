class FullStatsFifa15 < ActiveRecord::Migration
  def change

  	#General Info for all
  	add_column :players, :club, :string
  	add_column :players, :nationality, :string
  	add_column :players, :age, :integer
  	add_column :players, :height, :string
  	add_column :players, :attack_WR, :string
  	add_column :players, :defend_WR, :string
  	add_column :players, :weak_foot, :integer
  	add_column :players, :skill_moves, :integer
  	add_column :players, :starting, :boolean  	

	
	#Stats for outfielders
	add_column :players, :acceleration, :integer
	add_column :players, :sprint_speed, :integer
	add_column :players, :ball_control, :integer
	add_column :players, :dribbling_skill, :integer
	add_column :players, :agility, :integer
	add_column :players, :balance, :integer
	add_column :players, :curve, :integer
	add_column :players, :finishing, :integer
	add_column :players, :free_kick_accuracy, :integer
	add_column :players, :long_shots, :integer
	add_column :players, :penalties, :integer
	add_column :players, :shot_power, :integer
	add_column :players, :volleys, :integer
	add_column :players, :vision, :integer
	add_column :players, :crossing, :integer
	add_column :players, :long_passing, :integer
	add_column :players, :short_passing, :integer
	add_column :players, :heading_accuracy, :integer
	add_column :players, :jumping, :integer
	add_column :players, :strength, :integer
	add_column :players, :sliding_tackle, :integer
	add_column :players, :marking, :integer
	add_column :players, :standing_tackle, :integer
	add_column :players, :aggression, :integer
	add_column :players, :interceptions, :integer

	#Stats for GKs
	add_column :players, :diving, :integer
	add_column :players, :handling, :integer
	add_column :players, :kicking, :integer
	add_column :players, :positioning, :integer
	add_column :players, :reflexes, :integer

	#Old average stats
  	remove_column :players, :pace
  	remove_column :players, :shooting
  	remove_column :players, :passing
  	remove_column :players, :dribbling
  	remove_column :players, :defence
  	remove_column :players, :heading

  end
end
