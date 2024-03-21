# frozen_string_literal: true

require "redacting_logger"
require_relative "lib/retry_log_only"
require_relative "lib/faulty_service"

# setup a logger
$stdout.sync = true
log = RedactingLogger.new($stdout, level: ENV.fetch("LOG_LEVEL", "DEBUG").upcase)

# call this method as early as possible in the startup of your application
Retry.setup!(log:)

# import an example service that is flaky
fs = FaultyService.new

# now Retryable.with_context() will be available in your application anywhere
Retryable.with_context(:default) do
  puts "attempting a call to the faulty service..."
  fs.call
end
