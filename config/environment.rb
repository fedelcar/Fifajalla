# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'fedelc.us@gmail.com',
  :password => 'rstjywpiqlmlbwaq',
  :domain => 'gmail.com',
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => "plain",
  :enable_starttls_auto => true
}

require 'bleak_house' if ENV['BLEAK_HOUSE']
