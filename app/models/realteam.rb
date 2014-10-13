class Realteam < ActiveRecord::Base

	has_many :local_matches, :class_name => 'Match', :foreign_key => 'local_team_id'
	has_many :away_matches, :class_name => 'Match', :foreign_key => 'away_team_id'

	has_many :realplayers

end
