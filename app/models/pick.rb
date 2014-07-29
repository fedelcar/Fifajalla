class Pick < ActiveRecord::Base

	
	has_one :user
	has_one :player
end
