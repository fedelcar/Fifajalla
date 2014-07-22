class Trade < ActiveRecord::Base

	belongs_to :player

	#belongs_to :first_user, class_name => 'User'
	belongs_to :first_user
	#belongs_to :second_user, class_name => 'User'
	belongs_to :second_user
	#belongs_to :first_team, class_name => 'Team'
	belongs_to :first_team
	#belongs_to :second_team, class_name => 'Team'
	belongs_to :second_team

end
