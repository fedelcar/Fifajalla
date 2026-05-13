require File.expand_path('../boot', __FILE__)

require 'rails/all'

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
