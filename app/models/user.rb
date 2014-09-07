class User < ActiveRecord::Base

	has_many :local_matches, :class_name => 'Match', :foreign_key => 'local_user_id'
	has_many :away_matches, :class_name => 'Match', :foreign_key => 'away_user_id'

	has_many :first_user_trades, :class_name => 'Trade', :foreign_key => 'first_user_id'
	has_many :second_user_trades, :class_name => 'Trade', :foreign_key => 'second_user_id'

	has_many :teams

	has_one :stat, dependent: :destroy
		
		
	

	 def self.from_omniauth(auth)
	    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
		      user.provider = auth.provider
		      user.uid = auth.uid
		      user.name = auth.info.name
		      user.email = auth.info.email
		      if user.display_name == ""
			      user.gf=0
			      user.ga=0
			      user.wins=0
			      user.draws=0
			      user.loses=0
			      user.pts=0
			      user.dg=0
			      user.eff=0
			      user.elo=1500 
			  end
		  	  if !(User.exists?(user.id))
		  	  	user.display_name = user.name.split(" ").first
		  	  end

		      user.oauth_token = auth.credentials.token
		      user.oauth_expires_at = Time.at(auth.credentials.expires_at)

			  user.save
	    end
  	end

end
