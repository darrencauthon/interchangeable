# Setting

The `setting` library configures objects that can receive settings that are added to a configuration registry.

## Basic Examples

### Configuring an Object

```ruby
thing = Thing.new
Setting.configure thing
```

Any settings defined in the `Thing` class will be set by the values held in the registry.

### Specifying an Object's Settings

```ruby
class Thing
  include NullAttr

  null_attr_accessor :some_setting
end
```

Creates an attribute that can be set to values held in the registry.

### Registering an Object That Can Be Used as a Setting

```ruby
Setting::Registry.build do |registry|
  registry.some_setting = Something.new
end
```

An instance of the `Something` class is added to the registry. Any object with a setting named `some_setting` can receive the `Something` instance when the object is configured.

### Registering Via a Block

```ruby
Setting::Registry.build do |registry|
  registry.some_setting = -> { SomeOtherThing.new }
end
```

The value of `some_setting` is evaluated when an object is configured.

### Registering an Object for a Namespace

```ruby
Setting::Registry.build do |registry|
  registry.namespace 'SomeNamespace' do |namespace|
    namespace.some_setting = SomeOtherThing.new
  end
end
```

The registry is structured as a hierarchy that can be based on namespaces (eg: modules, nested classes, etc).

An instance of the `Something` class is added to the registry. Any object in the namespace `SomeNamespace` (i.e.: in a module named `SomeNamespace` or nested within an outer class named `SomeNamespace`) with a setting named `some_setting` can receive the `Something` instance when the object is configured.

The same setting name can be added to the registry as long as they are added in different namespaces.

This allows settings to be overridden based on the receiver's namespace.

### List the Settings for an Object

```ruby
thing = Thing.new
thing.some_setting = 'something'

puts Setting.settings(thing)
# => { :some_setting => 'something' }
```

### List the Settings for a Class

```ruby
puts Setting.settings(Thing)
# => { :some_setting => 'something' }
```

## Guidelines

### Objects with Settings are Useful Prior to Configuration

Classes with settings should be able to be instantiated without the use of the registry. The default value of setting attributes should respect the protocol of the setting's intended class.

Said otherwise, the default value of a setting prior to configuration should respect the `Dependency Inversion` principle.

Setting objects should not have query methods in their implementation. Methods should not return values. Settings respect the `Tell, Don't Ask` principle.

In the unfortunate event that a method on a setting object implementation is expected to return a value, use double-dispatch instead. Pass `self` to the method and expect the method implementation to set the value on the passed-in receiver rather than return the value.

The methods of dependencies should expect to be implemented as _fire and forget_.

### Avoid Lazy Configurations

Avoid the use of the registry outside of object construction. For example, avoid using the registry in a getter. Doing so couples the configured object to the registry at a time other than construction time.

Coupling the configured object at runtime to the registry violates the usefulness guideline above.

Using the registry at any time other than construction time (e.g.: in a getter) results in the `Service Locator` pattern. `Service Locator` should be avoided outside of object construction or else `Tell, Don't Ask` is violated, which will reduce the usefulness of the object, making testing of the object more complicated than desirable.

### Default Null Object Implementations

All settings are assigned to `Null Object` implementations by default.

With the expectation of setting objects to respect `Tell, Don't Ask`, null object implementations do not have to be any more complex that `no-op` methods that don't return anything.

_NOTE: `Null Object` implementations are provided by the `naught` library._

### Avoid Nested Configurations

Classes should avoid having settings that must also be configured by the registry. Classes should provide a means of being instantiated (i.e.: a `Foctory Method`) where nested dependencies are resolved explicitly.

_NOTE: This library intentionally avoids `Dependency Injection` framework features. Instead, it forces constraints that push the responsibility for dependency graph resolution to the software designer, and to design principles._

## Constraints

### Configured Objects Do Not Have Knowledge of Settings

Configured objects don't know about settings. An object of a class that defines settings using the `setting` macro, does not have in internal list of its settings. Only the settings library has knowledge of the settings.

To access an object's settings, the `Settings` module provides an API to lookup an object's list of settings, or the list of an object's settings and values.

## TODO

- null_attr lib
