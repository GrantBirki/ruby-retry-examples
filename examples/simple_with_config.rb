# frozen_string_literal: true

require "retryable"

# create a new configuration object
config = Retryable::Configuration.new

# set the configuration options
config.contexts     = {}
config.ensure       = proc {}
config.exception_cb = proc {}
config.log_method   = proc {}
config.matching     = /.*/
config.not          = []
config.on           = StandardError
config.sleep        = 1
config.sleep_method = ->(n) { Kernel.sleep(n) }
config.tries        = 4

# use the configuration object in the retryable block
Retryable.retryable(config) do
  puts "Hello, world!"
  raise StandardError, "This is an error"
end
