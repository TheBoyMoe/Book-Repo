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

Launch IRB and type `rspec/mocks/standalone` (returns true).

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

### Simple Stubs
  
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