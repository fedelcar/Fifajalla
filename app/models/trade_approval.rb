class Trade_Approval < ActiveRecord::Base
	belongs_to :trade
	has_one :user
end
