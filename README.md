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
  interchangeable_method :api_key
end
```

Elsewhere in your application, you can define the method like so:

```ruby
  Interchangeable.define MyApi, :api_key { 'anything' }

  MyApi.new.api_key # 'anything'

```

You can also provide a default implementation that can be overridden elsewhere:

```ruby
class MyApi
  interchangeable_method(:api_key) { 'abc' }
end

MyApi.new.api_key # 'abc'
```

**But why bother doing this?**

Interchangeable will provide you a list of the methods you have defined, as well as some helpful information.

```ruby
class MyApi
  interchangeable_method :apple
  interchangeable_method(:orange) { 'orange' }
  interchangeable_method :banana
end

Interchangeable.define(MyApi, :banana) { 'banana' }


Interchangeable.methods # [<target=MyApi, method_name=:apple,  implemented=false, default=false>,
                        #  <target=MyApi, method_name=:orange, implemented=true, default=true>,
                        #  <target=MyApi, method_name=:banana, implemented=true, default=false>]

```

This information can be helpful if you have a reusable system with many interchangeable parts.

## Installation

Add this line to your application's Gemfile:

    gem 'interchangeable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interchangeable
