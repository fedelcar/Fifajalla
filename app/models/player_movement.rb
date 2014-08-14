class Player_Movement < ActiveRecord::Base
	
	belongs_to :trade

	has_one :user
	has_one :user

	has_one :team
	has_one :team

	has_one :player
end
