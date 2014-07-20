class User < ActiveRecord::Base

	has_many :local_matches, :class_name => 'Match', :foreign_key => 'local_user_id'
	has_many :away_matches, :class_name => 'Match', :foreign_key => 'away_user_id'

	has_many :first_user_trades, :class_name => 'Trade', :foreign_key => 'first_user_id'
	has_many :second_user_trades, :class_name => 'Trade', :foreign_key => 'second_user_id'

	has_many :teams

	has_one :stat, dependent: :destroy

end
