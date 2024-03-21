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
