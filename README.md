# Gecko

Ruby gem for working with Geckoboard's Push API. Uses Faraday for HTTP and designed for use with
EventMachine and callbacks

http://docs.geckoboard.com/custom-widgets/

## Installation

Add this line to your application's Gemfile:

    gem 'gecko'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gecko

## Usage
```ruby
    # Configuration
    Gecko.config do |c|
      # Your Geckoboard API key
      c.api_key = '123456'
      # block invoked by Faraday#new
      # Set your http adapter here
      c.http_builder { |builder|
        builder.adapter :em_http
      }
    end

    # Update widget
    text_widget = Gecko::Widget::Text.new("1234-abcdefg")
    text_widget.add("this is the text", :alert)
    text_widget.update { |success, result| puts result.error unless success }

    # Update widget
    Gecko::Widget::Text.new("1234-abcdefg").on_update { |success, result|
      puts success ? "well done" : "#{result.error} [HTTP #{result.error.status}]"
    }.config! { |widget|
      widget.add("another test", :info)
    }

    # Delete previous values
    widget = Gecko::Widget::Text.new("1234-abcdefg")
    widget.reset.config! do |w|
      widget.add("text alert", :alert)
    end
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
