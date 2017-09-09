## Agile Development and OOD

Starts from the premise that customers can't define the software they want before they see it. It then follows that software should be built in tiny increments. At each stage you look for feedback from customer's and let that guide the next stage, each stage has the opportunity to alter the ideas of the next. You thus gradually iterate your way to an application that your customer's need. The collaboration/feedback produces software that could not have otherwise been anticipated by any other means. The alternative is you spend weeks/months building something to specification (on time and to budget), but at the end of the day the customer does not want.

The Agile process guarantees change. Your ability to make changes depends on your application's design. I you don't write well-designed code, you'll have to re-write your application at every iteration. Agile depends on simple, flexible and malleable code. OOD principles of SOLID, DRY etc, are about creating simple, flexible and malleable/maintainable code.

## Ruby and OOD

OO languages combine data and behaviour found in procedural languages into objects. BY encapsulating data, objects decide how much of the data they expose ot the world. Ruby is a Class-based OO language. A class is a blueprint for the construction of similar objects - they define methods (behaviour) and attributes/variables (data).  Object's invoke one another's methods as a means of sending messages. Each object instantiated from the same class, although having the same methods, behaviour, can have it's own data.

The foundation of OOD is the message, but the most visible organisational structure is the class. To begin with, the goal is to model your application using classes. Follow these steps:

1. Decide what methods belongs in a class - what classes you create will determine how you think about the application

2. Organize code that will allow for easy changes

  * changes should have no unexpected side effects - consequences of any change should be obvious in the code that is being changed and upon the code that relies on it.

  * a small change in requirements should require a corresponding small change in code - cost of any change should be proportional to any benefits.

  * any additional code should itself be easy to change

  * existing code is easy to re-use (DRY)

3. Classes should have a single responsibility (do the smallest possible thing)

  * have well-defined behaviour, means that they have fewer entanglements - are 'pluggable' or 'modular' - easier to replace.

  * results in classes that are easy to reuse

  * when classes have more than one use, if you want to reuse them else where, you end up with some behaviours you don't need. Classes with multiple responsibilities should not be reused.

  * classes with more than one use have many reasons why they might change - increases the chances of possibly breaking other classes that depend on it.

**How do you determine if your classes have a single responsibility?**

Interrogate the class as if it were sentient, e.g. if you had a Gear class, you might ask:

  * 'Mr Gear, what is your gear size?'

  * 'Mr Gear, what is your gear ratio?'

  * 'Mr Gear, what is your tyre size?'

From inside the Gear class, ever method may seem reasonable, but from the point of view of other objects, anything that Gear can respond to is another message that another object can send that could potentially be changed when Gear changes.

Another way is to describe the class in one sentence. If that sentence includes 'and', it likely has more that one responsibility. If it includes 'or', that it HAS more than one responsibility and they're not event related. This is the Single Responsibility Principal, everything in a class is related to it's central purpose - class is said to be 'highly cohesive'. This DOES NOT mean that the class does one single thing, but that everything is related to it's purpose.

4. Depend on behaviour, not data - always wrap instance variables in accessor methods, instead of directly referring to them, e.g.

```ruby
  class Gear
    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      @chainring / @cog.to_f      # <-- road to ruin
    end
  end

  # change the class above to the example below, attr_reader creates a simple wrapper method to read the variable
  class Gear
    attr_reader :chainring, :cog  # <-------

    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      chainring / cog.to_f        # <-------
    end
  end
```

The attr_reader creates a simple wrapper method to read the variable, cog. Implementing this method changes cog from data (which is referenced all over the class) to behaviour (which is defined once). You can also create a custom implementation, which would create a mess when implemented on individual variable references, e.g.

```ruby
  def cog
    @cog * (foo ? bar_adjustment : baz_adjustment)
  end
```

However, by encapsulating variables in this manner, your now making them visible to other objects in your application. You may want to make the behaviours private to the class.


5. Hide complicated data structures even from yourself.

```ruby
  class ObscuringReferences
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def diameters
      # 0 is rim, 1 is tire
      data.collect {|cell|
        cell[0] + (cell[1] * 2)}
      end
    # ... many other methods that index into the array
  end
```

The 'ObscuringReferences' class expects to be initialized with a 2d-array, which is accessible via the 'data' method. For 'data' to be useful, each caller of the method, e.g. 'diameters' must know what piece of data is at each index. Thus 'diameters', not only knows how to calculate diameters, but must also know that rims are at index [0] and tires are at index [1]. Which depends on the arrays structure. If that changes, 'diameters' needs to be changed. Any other place in our code that calls 'data' must also have that knowledge. The code is not DRY, since the knowledge needs to be duplicated - this knowledge should be known in just one place.

Ruby provides the 'Struct' class as a means to separate structure from meaning, e.g.

```ruby
  class RevealingReferences
    attr_reader :wheels

    def initialize(data)
      @wheels = wheelify(data)
    end

    def diameters
      wheels.collect {|wheel| wheel.rim + (wheel.tire * 2)}
    end
    # ... now everyone can send rim/tire to wheel

    Wheel = Struct.new(:rim, :tire)
    def wheelify(data)
      data.collect {|cell| Wheel.new(cell[0], cell[1])}
    end
  end
```

The 'diameters' method above knows nothing of the structure of the data array. All it knows is that 'wheels' returns an enumerable, each enumerated object(wheel) responds to 'rim' and 'tire'.
