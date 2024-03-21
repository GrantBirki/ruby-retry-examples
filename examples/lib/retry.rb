# frozen_string_literal: true

require "redacting_logger"
require "retryable"

module Retry
  # This method should be called as early as possible in the startup of your application
  # It sets up the Retryable gem with custom contexts and passes through a few options
  # :param log_method: a Proc/lambda that will be called with the number of retries and the exception
  # :param exception_cb: a Proc that will be called with the exception (useful for exception notification)
  # :param ensure_cb: a Proc that will be called after the retry block is finished...
  # ...regardless of whether an exception was raised
  def self.setup(log_method: nil, exception_cb: nil, ensure_cb: nil)
    # if a log_method was not provided, use a safe default
    if log_method.nil?
      log_method = lambda do |retries, exception|
        log.debug("[retry ##{retries}] #{exception.class}: #{exception.message} - #{exception.backtrace.join("\n")}")
      end
    elsif log_method == false
      log_method = proc {}
    else
      raise ArgumentError, "log_method must be a Proc, nil, or false but was a #{log_method.class}"
    end

    # if a exception_cb was not provided, use a safe default
    if exception_cb.nil?
      exception_cb = proc do |exception|
        # call something custom like the example below
        # ExceptionNotifier.notify_exception(exception, data: {message: "it failed"})
      end
    # if the exception_cb was disabled, unset it
    elsif exception_cb == false
      exception_cb = proc {}
    else
      raise ArgumentError, "exception_cb must be a Proc, nil, or false but was a #{exception_cb.class}"
    end

    # if an ensure callback was not provided, use a safe default
    if ensure_cb.nil?
      ensure_cb = proc do |retries|
        # this is just an example, you could do something like this
        puts "total retry attempts: #{retries}"
      end
    # if the ensure callback was disabled, unset it
    elsif ensure_cb == false
      ensure_cb = proc {}
    else
      raise ArgumentError, "ensure must be a Proc, nil, or false but was a #{ensure_cb.class}"
    end

    ######## Retryable Configuration ########
    # All defaults available here:
    # https://github.com/nfedyashev/retryable/blob/6a04027e61607de559e15e48f281f3ccaa9750e8/lib/retryable/configuration.rb#L22-L33
    Retryable.configure do |config|
      config.contexts[:faulty_service] = {
        on: [StandardError],
        sleep: 0.5,
        tries: 3,
        log_method:,
        exception_cb:,
        ensure: ensure_cb
      }
      config.contexts[:faulty_service_extra_slow] = {
        sleep: 2,
        tries: 3,
        log_method:,
        exception_cb:,
        ensure: ensure_cb
      }
    end
  end

  def self.log
    $stdout.sync = true
    @log ||= RedactingLogger.new($stdout, level: ENV.fetch("LOG_LEVEL", "DEBUG").upcase)
  end
end
