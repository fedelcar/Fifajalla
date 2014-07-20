class Team < ActiveRecord::Base

	has_many :local_matches, :class_name => 'Match', :foreign_key => 'local_team_id'
	has_many :away_matches, :class_name => 'Match', :foreign_key => 'away_team_id'

	has_many :first_team_trades, :class_name => 'Trade', :foreign_key => 'first_team_id'
	has_many :second_team_trades, :class_name => 'Trade', :foreign_key => 'second_team_id'

	has_many :players

	belongs_to :user

end
