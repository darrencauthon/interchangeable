# Setting

The `setting` library configures objects to receive settings that are added to a configuration registry.

The registry is structured as a hierarchy that can be based on namespaces (eg: modules, nested classes, etc).

## Examples

### Configuring an Object

```ruby
thing = Thing.new
Setting.configure thing
```

### Specifying an Object's Settings

```ruby
class Thing
  setting :some_setting
end
```

### Registering an Object That Can Be Used as a Setting

```ruby
Setting::Registry.build do |registry|
  registry.some_setting = Something.new
end
```

### Registering an Object for a Namespace

```ruby
Setting::Registry.build do |registry|
  registry.namespace 'SomeNamespace' do |namespace|
    namespace.some_setting = SomeOtherThing.new
  end
end
```

### Registering Via a Block

```ruby
Setting::Registry.build do |registry|
  registry.some_setting = -> { SomeOtherThing.new }
end
```

## TODO
- configure with namespace
- override with namespace

## Rules
- objects must provide a way to build themselves without the use of the container
