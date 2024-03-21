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
  puts "Hello, world! - with config! - 4 times!"
  # raise "This is an error"
end

# now set the config to 2 tries
config.tries = 2

Retryable.retryable(config) do
  puts "Hello, world! - with config! - 2 times!"
  raise StandardError, "This is an error"
end
