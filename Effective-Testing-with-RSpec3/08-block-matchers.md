## Block Matchers

There are instances where you want to check the properties or the side effects of a piece/block of code when it is run, e.g. does it raise an expectation, mutate variables, carry out some I/O. In those instances use block matchers. You can have RSpec execute the block and look for the specific side effects.

**raise_error**
		- check whether a code block throws an exception as expected
		- call `raise_error` with no arguments, matches any error raised.
		- `raise_error(SomeErrorClass)` matches 'SomeErrorClass' or subclass
		- `raise_error('some error message)` matches if the error raised generates an error message that exactly matches
		- `raise_error(/regex pattern/)` matches if an error is raised with amessage matching a given pattern. 
		- you can combine these:
		- `raise_error(SomeErrorClass, 'some message')`
		- `raise_error(SomeErrorClass, /regex pattern/)`
		- `raise_error(SomeErrorClass).with_message('some message')`
		- `raise_error(SomeErrorClass).with_message(/regex pattern/)`
		- you can also negate this, ie, check that a specific error was not raised, `expect().to_not raise_error(SomeErrorClass)`
		
**yield_control**
		- Ruby  allows any method to pass control to the caller with the `yield` keyword, RSpec provides a number of matchers, such as `yield_control`.
		- the method we're checking must yield to a block(or object that acts like a block)
		- RSPec provides such a block, a `block_checker`, that verifies that the method actually yielded to it.
		- RSpec provides the `yield_with_args` matcher for methods which take args
		- `yield_with_no_args` matcher to ensure no args are yielded to the block
		
```ruby
	def self.my_method
		yield	
	end
	
	expect {|block_checker| my_method(&block_checker)}.to yield_control
	
	expect {|block| my_method(&block)}.to yield_with_no_args
	
	def my_method(*args)
	  yield(*args)
	end
	
	expect {|block| my_method(10, 'my string', Math::PI, &block)}
						.to yield_with_args(10, /str/, a_value_within(0.1).of(3.14))					
```

**change**
		- check whether or not some state has changed
		- by specifying `by`, `by_at_least`, or `by_at_most` we can specify the amount
		- if you want to check before and after values, chain `from` and `to` to your matcher
		- RSPec does not allow you to negate your expectation when it includes any example using `by`, `by_` or `to`. It does work with `from`.
		
```ruby
	array = [1,2,3]
	expect {array << 4}.to change {array.size}
	
	​expect​ { array.concat([1, 2, 3]) }.to change { array.size }.by(3)
	​expect​ { array.concat([1, 2, 3]) }.to change { array.size }.by_at_least(2)
	expect​ { array.concat([1, 2, 3]) }.to change { array.size }.by_at_most(4)
	
	​expect​ { array << 4 }.to change { array.size }.from(3)
	​expect​ { array << 5 }.to change { array.size }.to(5)
	​expect​ { array << 6 }.to change { array.size }.from(5).to(6)
	​expect​ { array << 7 }.to change { array.size }.to(7).from(6)
```


**output**
		- check what is output to $stdout or $stderr
		- this matcher will not work if you use the STDOUT constant explicitly or spawn a subprocess that writes to one of the streams. In that case use `to_stdout_from_any_process`
		
```ruby
	​expect​ { print ​'OK'​ }.to output('OK').to_stdout
	expect​ { warn ​'problem'​ }.to output(​/prob/​).to_stderr
	
	expect​ { system(​'echo OK') }.to output("OK\n").to_stdout_from_any_process
```