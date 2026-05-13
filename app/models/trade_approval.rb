class TradeApproval < ActiveRecord::Base
  belongs_to :trade
  has_one :user
end
