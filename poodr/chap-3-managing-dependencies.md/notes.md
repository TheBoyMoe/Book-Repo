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
