## Test Doubles

Test doubles, like stunt doubles, stand in fo another object during testing so allowing you to isolate the part of the system your testing.
- this allows you to test a part of the system before it's dependencies are built
- use an API that your still designing, allowing you to fix design problems before implemnting them.
- demonstrate how a component works in relation to it's neighbours
- makes your tests faster and more resilient
- RSpec tears down all test doubles after each example, thus they won't 'play' well with RSpec features such as `before(:context)` hooks.

There a several 'types' of doubles:

1. the 'stub' - returns a canned response, no computation or I/O carried out

2. the 'mock object' - expects a specific message, will raise an error if not received

3. 'null object' - can stand in for any object, returns itself in response to any message

4. the 'spy' - records the message received, which can be checked later. 

A double ca be an instance of a Ruby object, an object provided by the test framework or a fake object that can be setup to have certain properties/behaviour.

You can explore the different types of double in an IRB session. 

Launch IRB and type `require 'rspec/mocks/standalone'` (returns true).

### Basic Double
 
```ruby  
	# - acts like an ordinary Ruby object
  ledger = double #=> #<Double (anonymous)> 
  
  # by default doubles will raise an error to any message sent
  ledger.record(an: :expense) 
  #=> raises an exception, #<Double (anonymous)> received unexpected message :record with ({:an=>:expense})
	
	# when you define a double, you giv it a role
  ledger = double('Ledger') #=> #<Double "Ledger">, object contains the role name
  ledger.record 
  #=> raises an exception, #<Double "Ledger"> received unexpected message :record with (no args)
```

### Stubs
  
Best for when you need to simulate a 'query' method - return a value, but does not produce side effects(modifies some state outside its scope or has an observable interaction with its calling function, e.g. modify a global variable, modify one of it's args, raise an exception, write to a file). 

- to create one, pass two or more args to 'double', 1st is the double role, subsequent args are key/value pairs which specify the method names and their respective return values.
-such stubs are useful where you're querying a dependency, e.g. database, may/may not perform some computation on the retrieved data and return a result. Your spec can check  the your object's behaviour by looking at the return value.

```ruby
  http_response = double('HTTPResponse', status: 200, body: 'OK')
  #=> #<Double "HTTPResponse">
  
  # you can do this in separate steps
  http_response = double('HTTPResponse') 
  allow​(http_response).to receive_messages(status: 200, body: 'OK')
  #=> {:status=>200, :body=>"text response"}
  
  # or
  allow​(http_response).to receive(:status).and_return(200)
  #=> #<RSpec::Mocks::MessageExpectation #<Double "HTTPResponse">.status(any arguments)> 
  allow​(http_response).to receive(:body).and_return('OK')
  #=> #<RSpec::Mocks::MessageExpectation #<Double "HTTPResponse">.body(any arguments)> 
  
  # usage
  http_response.status
	#=> 200
	http_response.body
	#=> 'OK'
  
  # Simple stubs look for a specific message, and respond with the same value each time, 
  # no matter what args are passed
  http_response.status(:one, :two)
  #=> 200
  
```

### Mock Objects

Mocks are useful when testing 'command' methods - you don't care about the return value, only the 'side effect', e.g. a method receives an event(chatbot receives a text message), as a result performs some action(decides on the reply), which in turn has a side effect(posts to a chat room). In order to test our method, we need to check that it triggered the side effect of posting to the chat room correctly.

To test this scenario, you would create a double and configure it with a set of messages it's supposed to receive, 'message expectations', declaring them in the same way you would a normal expectation in your specs.

```ruby
	ledger = double('Ledger')
	expect(ledger).to receive(:record)
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Ledger">.record(any arguments)> 

	# Typically at the end of each spec example RSpec verifies that any mock used receives their expected messages, otherwise a 'MockExpectationError' is raised.
  # In irb you can simulate this by running
  RSpec::Mocks.verify
  #=>  RSpec::Mocks::MockExpectationError: (Double "Ledger").record(*(any args))
	#=>		expected: 1 time with any arguments
	#=>		received: 0 times with any arguments 	 
```

When a mock object does not receive the message(s) it is expecting, it raise a 'MockExpectationError', and the spec example fails. You can also negate the `receive` expectation with `not_to` or `to_not` to make sure the mock does not receive a message. It will thus fail if it does.

```ruby
	expect(ledger).no_to receive(:reset)
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Ledger">.reset(any arguments)> 
  
  ledger.reset
  #=> RSpec::Mocks::MockExpectationError: (Double "Ledger").reset(no args)
  #=>    expected: 0 times with any arguments
  #=>    received: 1 time

```

In these two examples we're checking that a message was or was not sent to the mock, better use for a 'spy', not that some 'side effect' occurred.


### Null Objects

Both stubs and mocks require that you pre-configure them as to the messages they receive and the values they return. A null object is a double which will respond to any message(you can chain multiple methods), without raising an exception, and return itself. Create a null object by calling `as_null_object` on any double.

```ruby
	account = double('Account').as_null_object
	
	# or
 	account = double('Account')
 	account.as_null_object
 	
 	#=> #<Double "Account">
 	
	account.withdraw(200)
	#=> #<Double "Account">	
```

Null objects do nothing, can stand in for anything and can satify any interface. Null objects are useful when testing an object that has multiple collaborators, e.g. a chatbot that interacts with a room and a user. When testing either the room or user, you can use a null object for the chatbot.


### Spies

Used when you want to confirm that messages are being received. There are a number of approaches;
1. use a null object


```ruby
	# Game class
  class Game
  	def self.play(character)
  	  character.jump
  	end 
	end

	# define a null object
  mario = double('Mario').as_null_object
  #=> #<Double "Mario"> 
  Game.play(mario)
  #=> #<Double "Mario"> 
  expect(mario).to have_received(:jump)
  #=> nil # if Game.play(mario) had not been called, this would have thrown a 'MockExpectationError' exception
  expect(mario).not_to have_received(:jump)
  #=> RSpec::Mocks::MockExpectationError: (Double "Mario").jump(no args)
  #=>    expected: 0 times with any arguments
  #=>    received: 1 time
  # demonstrates that 'jump' was called
```

2. use a double with an explicit call to `allow`

```ruby
	# define a double giving it a role
	mario = double('Mario')
	#=> #<Double "Mario"> 
  allow(mario).to receive(:jump)
  #=> #<RSpec::Mocks::MessageExpectation #<Double "Mario">.jump(any arguments)> 
  Game.play(mario)
  #=> nil
  expect(mario).to have_received(:jump)
  #=> nil
  expect(mario).to_not have_received(:jump)
  #=> RSpec::Mocks::MockExpectationError: (Double "Mario").jump(no args)
  #=>   expected: 0 times with any arguments
  #=>   received: 1 time
	
```

3. use the rspec `spy` method 


```ruby
	mario = spy('Mario')
	#=> #<Double "Mario"> 
	Game.play(mario)
	#=> #<Double "Mario"> 
	expect(mario).to have_received(:jump)
	#=> nil
  expect(mario).to_not have_received(:jump)
	#=> RSpec::Mocks::MockExpectationError: (Double "Mario").jump(no args)
  #=>    expected: 0 times with any arguments
  #=>    received: 1 time 
```
