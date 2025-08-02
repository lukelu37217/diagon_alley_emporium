# Performance monitoring
class PerformanceMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.current
    status, headers, response = @app.call(env)
    end_time = Time.current
    
    # Log slow requests
    duration = end_time - start_time
    if duration > 1.0
      Rails.logger.warn "Slow request: #{env['REQUEST_METHOD']} #{env['PATH_INFO']} - #{duration.round(3)}s"
    end
    
    [status, headers, response]
  end
end
