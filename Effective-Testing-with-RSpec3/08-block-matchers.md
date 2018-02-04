## Block Matchers

There are instances where you want to check the properties or the side effects of a piece/block of code when it is run, e.g. does it raise an expectation, mutate variables, carry out some I/O. In those instances use block matchers. You can have RSpec execute the block and look for the specific side effects. Take the form

```ruby
	expect {code}.to matcher
	
	#=> negated with 'to_not' or 'not_to'
	expect {code}.to_not matcher 
```


### Available Matchers


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
		- 'change' mature captures a value before running the block (old_value) and again after running the block (new_value)
		- by specifying `by`, `by_at_least`, or `by_at_most` we can specify the amount
		- if you want to check before and after values, chain `from` and `to` to your matcher
		- RSPec does not allow you to negate your expectation when it includes any example using `by`, `by_` or `to`. It does work with `from`.
		
```ruby
	# general form
  expect {do_something}.to change(obj, :attr)
  expect {do_somthing}.to change {obj.attr}
  
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


## Summary of Matchers


```markdown

	**change**
	
	| Matcher        						| Passes If	           		  																 	 | Available aliases	 |
	|:-------------------------:|:------------------------------------------------------------:|:-------------------:|
	| change {}									|	old_value != new_value																			 |										 |		
	| change {}.by(x)						|	(new_value - old_value) == x   															 |										 | 	
	| change {}.by_at_least(x)	|	(new_value - old_value) >= x   															 |										 |	
	| change {}.by_at_most(x)		|	(new_value - old_value) <= x   															 |										 |	
	| change {}.from(x)					|	old_value != new_value && old_value == x   									 |										 |	
	| change { }.to(y)   				| old_value != new_value && new_value == y |									 |										 |
	| change { }.from(x).to(y)  | old_value != new_value && old_value == x && new_value == y   |    								 |
	|														|																															 |										 |
	
	
	**output**
			
	| Matcher        														| Passes If	           		 											 	| Available aliases  			  		 												|
	|:-----------------------------------------:|:-----------------------------------------------:|:-----------------------------------------------------:|
	| output("foo").to_stdout 									|	"foo" is printed to $stdout* 										|	a_block_outputting("foo").to_stdout									  |	
	| output("foo").to_stderr										|	"foo" is printed to $stderr*   								  |	a_block_outputting("foo").to_stderr									  |	
	| output(/bar/).to_stdout										|	A string matching /bar/ is printed to $stdout* 	|	a_block_outputting(/bar/).to_stdout									  |	
	| output(/bar/).to_stderr										|	A string matching /bar/ is printed to $stderr* 	|	a_block_outputting(/bar/).to_stderr									  |	
	| output("foo").to_stdout_from_any_process	|	"foo" is printed to $stdout* 	   							  |	a_block_outputting("foo").to_stdout_from_any_proces		|	
  | output("foo").to_stderr_from_any_process	| "foo" is printed to $stderr*										| a_block_outputting("foo").to_stderr_from_any_process	|
  | output(/bar/).to_stdout_from_any_process	| A string matching /bar/ is printed to $stdout*	| a_block_outputting(/bar/).to_stdout_from_any_process	|
  | output(/bar/).to_stderr_from_any_process	| A string matching /bar/ is printed to $stderr*	| a_block_outputting(/bar/).to_stderr_from_any_process	|
  
  * from this process
  ** from this process or a subprocess	
  
  
  **raise errors**
  
  	
 	| Matcher        								| Passes If	           		  																									| Available aliases  			  		 		|
 	|:-----------------------------:|:---------------------------------------------------------------------------:|:---------------------------------:|
 	| raise_error("message")				|	Block raises an error and error.message == "message"   											|	raise_exception("message")				|	
 	| 											 				|																											   											|	a_block_raising("message")				|	
 	| raise_error(/regexp/)					|	Block raises an error and error.message =~ /regexp/   											|	raise_exception("message")				|
 	| 											 				|																											   											|	a_block_raising("message")				|
 	| raise_error(klass)						|	Block raises an error and error.is_a?(klass)   															|	raise_exception(klass)						|
 	| 											 				|																											   											|	a_block_raising(klass)						|
 	| raise_error(klass, "message")	|	Block raises an error and error.is_a?(klass) && error.message == "message"  |	raise_exception(klass, "message")	|	
 	| 											 				|																											   											|	a_block_raising(klass, "message")	|
 	| raise_error(klass, /regexp/)	|	Block raises an error and error.is_a?(klass) && error.message =~ /regexp/   |	raise_exception(klass, /regexp/)	|
 	| 											 				|																											   											|	a_block_raising(klass, /regexp/)	|	
 	| raise_error { |err| ... })		| Block raises an error and raise_error block returns true										| raise_exception { |err| ... }			|
 	| 											 				|																											   											|	a_block_raising { |err| ... }			|
 	| throw_symbol									| Block throws any symbol																											| a_block_throwing									|	
 	| throw_symbol(:sym)						| Block throws symbol :sym																										| a_block_throwing(:sym)						|
 	|	throw_symbol(:sym, arg)				| Block throws symbol :sym with argument arg																	|	a_block_throwing(:sym, arg)				|	
 	|																|																																							|																		|	
 	
 	
 	**yield**
 	
 	| Matcher        												| Passes If	           		  																				| Available aliases 								 			  		 		|
  |:-------------------------------------:|:-----------------------------------------------------------------:|:-------------------------------------------------:|
 	| yield_control													| method yields to block on or more times														| yield_control.at_least(:once)											|		
 	|																				|																																		| a_block_yielding_control 													|																						
	|																				| method yields to block once																				|	a_block_yielding_control.once											|		
 	| yield_control.once										| method yields to block twice																			| a_block_yielding_control.twice    								|
 	| yield_control.twice										| method yields to block thrice																			| a_block_yielding_control.thrice										|
 	| yield_control.thrice									| method yields to block n times																		| a_block_yielding_control.exactly(n).times					|
 	| yield_control.exactly(n).times				| method yields to block at least n times														| a_block_yielding.at_least(n).times								|
 	| yield_control.at_most(n).times				| method yields to block at most n times														| a_block_yielding.at_most(n).times									|			
 	| yield_with_args(x, y)									| method yields to block once with args x and y											| a_block_yielding_with_args(x, y)									|
 	| yield_with_no_args										| method yields to block once with no args													| 																									|									
 	|	yield_successive_args([a, b], [c, d])	| method yields to block once with args a and b, once with c and d  | a_block_yielding_successive_args([a, b], [c, d])  |
 	|																				|																																		|																										|
```	