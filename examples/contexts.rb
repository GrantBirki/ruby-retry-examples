# frozen_string_literal: true

require "retryable"

FaultyServiceTimeoutError = Class.new(StandardError)

class FaultyService
  def initialize
    @tries = 0
  end

  def call
    @tries += 1
    raise FaultyServiceTimeoutError if @tries < 3
  end
end

fs = FaultyService.new

# create a config context
Retryable.configure do |config|
  config.contexts[:faulty_service] = {
    on: [FaultyServiceTimeoutError],
    sleep: 0.5,
    tries: 3
  }
end

# use that config context
Retryable.with_context(:faulty_service) do
  puts "executing with context"
  fs.call
end

fs = FaultyService.new

# modify the config context
Retryable.with_context(:faulty_service, sleep: 2) do
  puts "executing with modified context - slower sleep"
  fs.call
end
