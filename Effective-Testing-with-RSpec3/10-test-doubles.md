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

```ruby
	# basic double - acts like an ordinary Ruby object
  ledger = double #=> #<Double (anonymous)> 
  
  # by default doubles will raise an error to any message sent
  ledger.record(an: :expense) 
  #=> raises an exception, #<Double (anonymous)> received unexpected message :record with ({:an=>:expense})
	
	# when you define a double, you giv it a role
  ledger = double('Ledger') #=> #<Double "Ledger">, object contains the role name
  ledger.record 
  #=> raises an exception, #<Double "Ledger"> received unexpected message :record with (no args)

	
```