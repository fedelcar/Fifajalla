Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = true

  config.assets.js_compressor = nil
  config.assets.compile = false
  config.assets.digest = true

  config.log_level = :info
  config.i18n.fallbacks = true
  config.active_support.deprecation = :log
  config.log_formatter = ::Logger::Formatter.new

  logger = ActiveSupport::Logger.new($stdout)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.active_record.dump_schema_after_migration = false
end
