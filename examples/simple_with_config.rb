# frozen_string_literal: true

require "retryable"

Retryable.configure do |config|
  config.contexts     = {}
  config.ensure       = proc {}
  config.exception_cb = proc {}
  config.log_method   = proc {}
  config.matching     = /.*/
  config.not          = []
  config.on           = StandardError
  config.sleep        = 1
  config.sleep_method = ->(n) { Kernel.sleep(n) }
  config.tries        = 2
end

Retryable.retryable do
  puts "Hello, world!"
  raise StandardError, "This is an error"
end
