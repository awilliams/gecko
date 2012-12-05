# Gecko [![Build Status](https://secure.travis-ci.org/awilliams/Gecko.png?branch=master)](https://travis-ci.org/awilliams/Gecko)

Ruby gem for working with Geckoboard's Push API.

Features:
* Uses Faraday gem for HTTP. You can easily swapout adapters
* Designed for use with non-blocking requests (EventMachine)
* Allows for multiple widget keys per widget object. Useful for updating widgets on multiple dashboards at once

http://docs.geckoboard.com/custom-widgets/

## Installation

Add this line to your application's Gemfile:

    gem 'gecko'

Recommended for use with Eventmachine. Add these to your Gemfile

    gem 'eventmachine'
    gem 'em-http-request'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gecko

## Usage
### Configuration
```ruby
# Configuration
Gecko.config do |c|
  # Your Geckoboard API key
  c.api_key = '123456'
  # block invoked by Faraday#new
  # Set your http adapter here, otherwise Faraday.default_adapter is used
  c.http_builder { |builder|
    # use EventMachine Http adapter for non-blocking updates
    builder.adapter :em_http
  }
end
```

### Update Widgets
```ruby
# Update widget
text_widget = Gecko::Widget::Text.new("1234-widget-key")
text_widget.add("some info")
text_widget.add("this is the text", :alert)
text_widget.update { |success, result, widget_key|
  puts success ? "Updated" : "Error updating #{widget_key}: #{result.error}"
}

# Update widget using #config!
text_widget = Gecko::Widget::Text.new("1234-widget-key").on_update do |success, result, widget_key|
  # this block is executed on every update
  puts success ? "Updated" : "Error updating #{widget_key}: #{result.error}"
end
text_widget.config! do |widget|
  text_widget.add("some info")
  text_widget.add("this is the text", :alert)
end

# Update multiple widgets at once - useful for same widget on various dashboards
text_widget = Gecko::Widget::Text.new("1234-widget-key", "1234-second-widget-key").on_update do |success, result, widget_key|
  # this block is executed TWICE every update since there are two widgets being updated
  puts success ? "Updated" : "Error updating #{widget_key}: #{result.error}"
end
text_widget.config! do |widget|
  text_widget.add("some info")
  text_widget.add("this is the text", :alert)
end
```

### Delete reset widget values
```ruby
widget = Gecko::Widget::Text.new("1234-abcdefg")
# reset clear out previous items
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
