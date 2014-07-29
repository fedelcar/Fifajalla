class Event < ActiveRecord::Base

	belongs_to :player
	has_one :user
	has_one :event_type
end
