require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Fifajalla
  class Application < Rails::Application
    config.time_zone = 'Buenos Aires'
    config.active_support.cache_format_version = 7.1

    config.assets.enabled = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile += %w( .svg .eot .woff .ttf )
  end
end
