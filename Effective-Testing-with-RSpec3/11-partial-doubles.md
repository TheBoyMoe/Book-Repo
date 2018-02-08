## Partial Doubles

All the doubles looked at so far are 'pure doubles', purpose built mocks, spies and stubs that have a consistent behaviour. They're best used where you pass in a dependency into your code.

Real world apps often don't give you an easy way to inject dependencies, e.g. an api may have hard coded attributes, such as a name, or an app may call `Time.now` without providing a way to override this behaviour in testing.

In such situations you can use a 'partial double'. These add mocking and/or stubbing behaviour to an existing Ruby object. By using `allow` or `expect` with a specific message, any object can be used as a partial double.

```ruby
	# create a random number generator
  random = Random.new(1)
	#=> #<Random:0x0000000000bf90a0>
  random.rand #=> 0.12271798938122425
  random.rand #=> 0.7520613454834647 
  
  # replace it's 'rand' method with one that returns a canned value(stub)
 	# all it's other methods work as normal
  allow(random).to receive(:rand).and_return(0.123456789)
  #=> #<RSpec::Mocks::MessageExpectation #<Random:0x0000000000bf90a0>.rand(any arguments)> 
  random.rand #=> 0.123456789 
  random.rand #=> 0.123456789
  
  # you can also add messages
  allow(random).to receive(:jump).and_return('jumping')
	#=> #<RSpec::Mocks::MessageExpectation #<Random:0x0000000000bf90a0>.jump(any arguments)> 
  random.jump #=> 'jumping' 
```

You can also use a partial double as a 'spy', using `allow` and `expect().to have_received`.

```ruby
	allow(Dir).to receive(:make_tmp_dir).and_yield('/path/to/tmp')
	#=> #<RSpec::Mocks::MessageExpectation #<Dir (class)>.make_tmp_dir(any arguments)> 
  Dir.make_tmp_dir {|dir| puts "Dir is #{dir}"}
	#=>  "Dir is /path/to/tmp
	#=> nil
  expect(Dir).to have_received(:make_tmp_dir)
  #=> nil
  expect(Dir).to_not have_received(:make_tmp_dir)
  #=> RSpec::Mocks::MockExpectationError: (Dir (class)).make_tmp_dir(no args)
  #=>    expected: 0 times with any arguments
  #=>    received: 1 time
```

Note: when using a partial double as a 'spy', your limited to calling messages you've defined before hand. You cannot permit 'any' message as you can with a null object or when using the RSpec 'spy' method.

At the end of each example Ruby will revert the Ruby object back to it's original behaviour - no problem with doubles 'leaking' into other specs.

Note: in irb you need to call `RSpec::Mocks.teardown` to explicitly clean up your partial doubles.


### Verifying Doubles

Mocks, stubs and other doubles are often created before the underlying Ruby class exists. A problem then occurs when you change the class in some way, e.g. rename a method, which is not reflected in the specs, your real-world app breaks(trying to call a method that no longer exists) but the specs carry on passing - the change not being picked up. In order to overcome this limitation use the `instance_double` instead of the `double` method when instantiating a double - RSpec checks that the actual Class responds in the way the double is being used.

Note: Although your unit specs would have had a false positive here, your  acceptance specs should catch this sort of regression since they use the real versions of the objects, rather than  counting on test doubles.

```ruby
	 module ExpenseTracker

   	class Ledger
   		def record(expense)
   			
   		end   	  
   	end
   	
   end
	
	ledger = double(ExpenseTracker::Ledger)
	#=> #<Double ExpenseTracker::Ledger> 
	allow(ledger).to receive(:record)
	#=> #<RSpec::Mocks::MessageExpectation #<Double ExpenseTracker::Ledger>.record(any arguments)>
  allow(ledger).to receive(:record_plus)
  #=> #<RSpec::Mocks::MessageExpectation #<Double ExpenseTracker::Ledger>.record_plus(any arguments)> 
 
 	strict_ledger = instance_double(ExpenseTracker::Ledger)
	#=> #<InstanceDouble(ExpenseTracker::Ledger) (anonymous)> 
	allow(strict_ledger).to receive(:record)
	#=> #<RSpec::Mocks::VerifyingMessageExpectation #<InstanceDouble(ExpenseTracker::Ledger) (anonymous)>.record(any arguments)>
	allow(strict_ledger).to receive(:record_plus)
	#=> #MockExpectationError: the ExpenseTracker::Ledger class does not implement the instance method: record_plus
    
```

Rspec provides a number of methods:

- `instance_double('SomeClass')` - Constrains the double’s interface using the instance methods ofSomeClass 

- `class_double('SomeClass')` - Constrains the double’s interface using the class methods ofSomeClass

- `object_double(some_object)` - Constrains the double’s interface using the methods of some_object,rather than a class; handy for dynamic objects that usemethod_missing.

RSpec also provides `_spy` versions of each of these methods.