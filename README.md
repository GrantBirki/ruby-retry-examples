# ruby-retry-examples 🔄

A sandbox repository containing examples of Ruby retry logic

## Setup 🛠

Run `script/bootstrap` to install dependencies

## Running the examples 🏃‍♂

Find an example you would like to run in the `examples/` directory and run it with:

```bash
bundle exec ruby examples/<example_name>.rb
```

## Best ⭐

My favorite flavor of retry logic can be found in the [`examples/app_log_only.rb`](examples/app_log_only.rb) file. It demonstrates a dead simple retry method that comes with a `:default` context and you provide your own logger.

Note: If you are going to use the `examples/app_log_only.rb` example, and want to capture the last exception that is rais (i.e you ran out of retries) here is how you can do it:

```ruby
begin
  Retryable.with_context(:default) do
    puts "attempting a call to the faulty service..."
    fs.call
  end
rescue StandardError => e
  # you have to capture the entire block other wise it will interfere with the retry logic
  puts "ran out of retries, here is the exception: #{e}"
end
```
