# Setting

The `setting` library configures objects that can receive settings that are added to a configuration registry.

## Project Status: Exploratory Specification

The `setting` library is not implemented.

This specification is exploratory. Although a number of the techniques and tools mentioned here have been implemented individual in other projects, thay have not been assembled as a cohesive library.

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
  attr_accessor :some_setting
end
```

Creates an attribute that can be set to values held in the registry.

### Registering an Object That Can Be Used as a Setting

```ruby
Setting::Registry.build do |registry|
  registry[:some_setting] = Something.new
end
```

An instance of the `Something` class is added to the registry. Any object with a setting named `some_setting` can receive the `Something` instance when the object is configured.

### Registering Via a Block

```ruby
Setting::Registry.build do |registry|
  registry[:some_setting] = -> { SomeOtherThing.new }
end
```

The value of `some_setting` is evaluated when an object is configured.

### Registering an Object for a Namespace

```ruby
Setting::Registry.build do |registry|
  registry.namespace 'SomeNamespace' do |namespace|
    namespace[:some_setting] = SomeOtherThing.new
  end
end
```

The registry is structured as a hierarchy that can be based on namespaces (eg: modules, nested classes, etc).

An instance of the `SomeOtherThing` class is added to the registry. Any object in the namespace `SomeNamespace` (i.e.: in a module named `SomeNamespace` or nested within an outer class named `SomeNamespace`) with a setting named `some_setting` can receive the `SomeOtherThing` instance when the object is configured.

The same setting can be added to the registry as long as they are added to different namespaces. This allows settings to be overridden based on the receiver's namespace.

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
# => { :some_setting => the_value_of_the_setting_held_in_the_registry }
```

## Design Guidelines for Configurable Objects

### Objects with Settings are Useful Prior to Configuration

Classes with settings should be able to be instantiated without the use of the registry.

The default value of setting attributes should respect the protocol of the setting's intended class, i.e.: the default value shouldn't be `nil`. Said otherwise, the default value of a setting prior to configuration should respect the `Dependency Inversion` principle.

The values of the settings should avoid having query methods in their implementation, i.e.: methods on setting abouts should not return values. Settings respect the `Tell, Don't Ask` principle.

In the unfortunate event that a method on a setting object implementation is expected to return a value, use double-dispatch instead. Pass `self` to the method and expect the method implementation to set the value on the passed-in receiver rather than return the value. Don't "pull" values from an object and then assign those values to other variables. Instead, pass in the object that would receive those values and let the dependency control how _its_ values are assigned to other objects.

The methods of dependencies should expect to be implemented as _fire and forget_.

### Avoid Lazy Configurations

Avoid the use of the registry outside of object construction. For example, avoid using the registry in a getter. Doing so will likely couple the configured object to the registry during the execution of application logic rather than at construction time.

Coupling the configured object at runtime to the registry violates the usefulness guideline above. Separate uses of the registry from application logic.

Using the registry at any time other than construction time (e.g.: in a getter) is a use of the `Service Locator` pattern. `Service Locator` should be avoided outside of object construction or else `Tell, Don't Ask` is violated. This will reduce the usefulness of the object, making the testing of the object more complicated than necessary.

### Default Null Object Implementations

Use `Null Object` as default values for settings.

`Null Object` implementations do not have to be any more complex that `no-op` methods that don't return anything.

_NOTE: `Null Object` implementations can be created using the [null_attr](https://github.com/Sans/null_attr) library._

### Avoid Nested Configurations

Classes should avoid having settings that must also be configured by the registry. Classes should provide a means of being instantiated (i.e.: a `Foctory Method`) where nested dependencies are resolved explicitly.

_NOTE: This library intentionally tries to avoid a `Dependency Injection` mindset that was (or still is) common to .NET and Java IoC/DI frameworks. Instead, it forces constraints that push the responsibility for dependency graph resolution to the software designer, and to design principles. It's unclear at this point (Wed Oct 01 2014) whether resolution of nested configurations will be a feature of this library._

## Constraints

### Configured Objects Do Not Have Knowledge of Settings

Configured objects don't know about settings. An object of a class that defines settings using the `setting` macro, does not have in internal list of its settings. Only the settings library has knowledge of the settings.

To access an object's settings, the `Settings` module provides an API to lookup an object's list of settings, or the list of an object's settings and values.

## License

The `setting` library is released under the [MIT License](https://github.com/Sans/setting/blob/master/MIT-license.txt).
