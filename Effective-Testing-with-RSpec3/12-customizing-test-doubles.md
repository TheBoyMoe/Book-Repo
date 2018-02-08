## Customizing Test Doubles

1. Configure how a double responds to a call

- doubles respond with `nil` unless you specifically configure a response.
- you can configure doubles to return a value, raise an error, yield to a block, or throw a symbol. 


```ruby
	# test doubles
	allow(double).to receive(:message).and_return(value)
	allow(double).to receive(:message).and_yield(a_value_to_a_block)
	allow(double).to receive(:message).and_raise(exception)
	allow(double).to receive(:message).and_throw(:symbol, optional_value)
	allow(double).to receive(:message) {|arg| do_something_with(arg)}
	
	# partial doubles
  # A call such as 
  expect(some_existing_object).to receive(:message) #=> return nil 
  # doesn't just set up an expectation, it changes the behaviour of the existing object.
  # In order to add a message expectation, and retain the original implementation, call `and_call_original`
  allow(object).to receive(:message).and_call_original
  allow(object).to receive(:message).and_wrap_original {|original|} 
```

**and_return**

You can also have your double return multiple values with the `and_return` call

```ruby
	random = Random.new(1)
	allow(random).to receive(:rand).and_return(0.1,0.2,0.3)
	
	random.rand #=> 0.1
	random.rand #=> 0.2
	random.rand #=> 0.3
	random.rand #=> 0.3
```

The values are returned in sequence, once the last value is reached it will be returned on each subsequent call


**and_yield**

You can yield multiple values to a block by chaining together multiple `and_yield` calls.

```ruby
	extractor = double('URLExtractor')
	allow(extractor).to receive(:extract_urls).and_yield('http://url/1', 123456).and_yield('http://url/2', 234567).and_yield('http://url/3', 345678)
	
	# when we call the `extract_urls` method with a block, the method will yield to the block three times
	extractor.extract_urls {|url, id| puts "#{url} : #{id}"}
	# http://url/1 : 123456
  # http://url/2 : 234567
  # http://url/3 : 345678
  #=> nil 

```

**and_raise**

The `and_raise` method mirrors Ruby's raise method


```ruby
	class AnExceptionClass < Exception; end
	exception_instance = AnExceptionClass.new
	#=>  #<AnExceptionClass: AnExceptionClass> 
 
  double = double('Exception') 
	
	allow(double).to receive(:message).and_raise(exception_instance)
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Exception">.message(any arguments)>
	double.message
	#=> AnExceptionClass: AnExceptionClass
	
	allow(double).to receive(:message).and_raise(AnExceptionClass)
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Exception">.message(any arguments)> 
  double.message
  #=> AnExceptionClass: AnExceptionClass

  
	allow(double).to receive(:message).and_raise('An exception was raised')
  #=> #<RSpec::Mocks::MessageExpectation #<Double "Exception">.message(any arguments)> 
  double.message 
  #=> RuntimeError: An exception was raised


	allow(double).to receive(:message).and_raise(exception_instance, 'An exception was raised')
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Exception">.message(any arguments)> 
  double.message
  #=> AnExceptionClass: An exception was raised
 
```

2. Setting constraints