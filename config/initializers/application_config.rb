# Application configuration for security
Rails.application.configure do
  # Security headers
  config.force_ssl = false # Set to true in production
  
  # Session configuration
  config.session_store :cookie_store, key: '_diagon_alley_session'
  
  # Asset pipeline configuration
  config.assets.precompile += %w( custom.scss )
end
