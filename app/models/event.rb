class Event < ActiveRecord::Base

	belongs_to :player
	has_one :uses
	has_one :event_type
end
