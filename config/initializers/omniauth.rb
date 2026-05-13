OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [:get, :post]
OmniAuth.config.silence_get_warning = true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
end
