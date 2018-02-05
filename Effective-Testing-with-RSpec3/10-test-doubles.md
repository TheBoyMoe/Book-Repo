## Test Doubles

Test doubles, like stunt doubles, stand in fo another object during testing so allowing you to isolate the part of the system your testing.
- this allows you to test a part of the system before it's dependencies are built
- use an API that your still designing, allowing you to fix design problems before implemnting them.
- demonstrate how a component works in relation to it's neighbours
- makes your tests faster and more resilient

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

### Mocks

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






