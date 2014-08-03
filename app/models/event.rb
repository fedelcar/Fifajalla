class Event < ActiveRecord::Base

	belongs_to :player
	belongs_to :match
	has_one :event_type
end
