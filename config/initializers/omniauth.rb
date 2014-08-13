OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1451780838434124', '70819a2eb83e556d127ca80371f2ea05', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end