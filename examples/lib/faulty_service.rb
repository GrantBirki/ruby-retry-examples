# frozen_string_literal: true

class FaultyService
  def initialize
    @tries = 0
  end

  def call
    @tries += 1
    raise StandardError, "oh no" if @tries < 3
  end
end
