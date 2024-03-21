# frozen_string_literal: true

require_relative "lib/retry"
require_relative "lib/faulty_service"

# call this method as early as possible in the startup of your application
Retry.setup

# import an example service that is flaky
fs = FaultyService.new

# now Retryable.with_context() will be available in your application anywhere
Retryable.with_context(:faulty_service) do
  puts "attempting a call to the faulty service..."
  fs.call
end

# create another instance of the faulty service for testing the extra slow sleeps
fs = FaultyService.new

# use a different context for the extra slow sleeps
Retryable.with_context(:faulty_service_extra_slow) do
  puts "attempting a call to the faulty service with extra slow sleeps..."
  fs.call
end

# pass in an override to the context
Retryable.with_context(:faulty_service_extra_slow, sleep: 0.25) do
  puts "attempting a call to the faulty service with overrides in the context..."
  fs.call
end
