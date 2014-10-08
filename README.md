# Interchangeable

Create and maintain interchangeable components in Ruby. 

## Usage

```ruby
class MyApi
  def api_key
    "abc"
  end
end
```

can become

```ruby
class MyApi
  interchangeable_instance_method :api_key
end
```

Elsewhere in your application, you can define the method like so:

```ruby
  Interchangeable.define MyApi, :api_key { 'anything' }
```

## Installation

Add this line to your application's Gemfile:

    gem 'interchangeable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interchangeable
