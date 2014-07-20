class User < ActiveRecord::Base
	has_one :stat, dependent: :destroy
end
