## Managing Dependencies

Because a well designed objects have a single responsibility, they must collaborate in order to get things done. This means that they must know something of other object - this creates a dependency. An object is said to be dependent on another, if when one changes, the other might be forced to change.

```ruby
  class Gear
    attr_reader :chainring, :cog, :rim, :tire
    def initialize(chainring, cog, rim, tire)
      @chainring = chainring
      @cog       = cog
      @rim       = rim
      @tire      = tire
    end

    def gear_inches
      ratio * Wheel.new(rim, tire).diameter
    end

    def ratio
      chainring / cog.to_f
    end
  # ...
  end

  class Wheel
    attr_reader :rim, :tire
    def initialize(rim, tire)
      @rim       = rim
      @tire      = tire
    end

    def diameter
      rim + (tire * 2)
    end
  # ...
  end
```

First step is to recognise dependencies, as a general rule an object has a dependency on another when it knows:

1. the name of another class, e.g. Gear expects a class called Wheel to exist.

2. the name of a message that it intends to send to someone other than 'self', e.g. 'Gear' expects 'Wheel' instance to respond to 'diameter'.

3. the arguments that a message requires, e.g. 'Gear' knows that 'Wheel.new' requires 'rim' and 'tire'.

4. the order of those arguments, e.g. 'Gear' knows the first argument should be 'rim', the second 'tire'.

Dependencies mean that:
  - should 'Wheel' change, you will be forced to change 'Gear'.
  - should you want to use 'Gear' else where, you require 'Wheel'
  - when you test 'Gear', you're testing 'Wheel'.

Another form of dependency is created when many messages are chained together. You end up creating a dependency between the original object, and every object and message along the way to the final target. Any change to any intermediate object could force the first object to be changed - called Law of Demeter violation.

Another form of dependency is can be created when tests are tightly coupled to the code they're testing. Results in bests breaking when ever code is refactored, even though the underlying behaviour has not.

Each dependency creates a coupling between the two objects. Since objects must collaborate some degree of dependency/coupling is inevitable. The challenge is to keep these to a minimum.


### Techniques for de-coupling/reducing dependencies between objects

1. Dependency Injection

When one class refers to another by name, e.g. 'Gear' knows the name of 'Wheel', the 'Gear' is explicitly declaring that it is only willing to collaborate with the 'Wheel' even though there may be other objects that respond to the 'diameter' message. Thus the application could not be expanded to include other objects that have gears. It is not the class of the object that’s important, it’s the message you plan to send to it. Gear needs access to an object that can respond to diameter. 'Gear' should not care or know about the class of the object. Doing so reduces it's re-usability. Instead, 'Gear' should be initialized with an object that responds to the 'diameter' message.

```ruby
  class Gear
    attr_reader :chainring, :cog, :wheel
    def initialize(chainring, cog, wheel)
      @chainring = chainring
      @cog       = cog
      @wheel     = wheel
    end

    def gear_inches
      ratio * wheel.diameter
    end
  # ...
  end

  # Gear expects a 'Duck' that knows 'diameter'
  Gear.new(52, 11, Wheel.new(26, 1.5)).gear_inches
```

'Gear' now holds on to a 'wheel' object via the `@wheel` variable. This object could be any object that responds to 'diameter' - gear can now collaborate with any object that implements 'diameter'. This technique is known as Dependency Injection - the dependency on a specific class, 'Wheel', has been removed. Through injection, 'Gear's dependencies have been reduced to a single dependency on the 'diameter' message. Another benefit, 'Gear' no,longer knows about the 'rim' or 'tire' arguments or the order in which they have to be passed to the 'Wheel' initializer.
