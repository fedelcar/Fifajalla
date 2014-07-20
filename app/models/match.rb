class Match < ActiveRecord::Base

	belongs_to :local_user, class_name => 'User'
	belongs_to :away_user, class_name => 'User'

	belongs_to :local_team, class_name => 'Team'
	belongs_to :away_team, class_name => 'Team'
	
end
