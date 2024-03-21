# frozen_string_literal: true

require "retryable"

Retryable.retryable(tries: 3) do
  puts "Hello, world!"
  raise StandardError, "This is an error"
end
