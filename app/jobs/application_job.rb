class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encounter a StandardError
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  # Discard job if it encounters an unrecoverable error
  discard_on ActiveJob::DeserializationError

  private

  def log_error(error)
    Rails.logger.error "Job #{self.class.name} failed: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")
  end
end
