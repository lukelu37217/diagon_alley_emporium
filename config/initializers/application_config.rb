# Application configuration for security
Rails.application.configure do
  # Security headers
  config.force_ssl = false # Set to true in production
  
  # CORS configuration for API endpoints
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end if Rails.env.development?
  
  # Session configuration
  config.session_store :cookie_store, key: '_diagon_alley_session'
  
  # Asset pipeline configuration
  config.assets.precompile += %w( custom.scss )
end
