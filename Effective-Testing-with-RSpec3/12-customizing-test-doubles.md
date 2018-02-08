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


2. Setting constraints on arguments

The test doubles created so far can be called with or without any input. So if you stub a method `my_method` without args, you can then call it with or without args, or pass it a block and RSpec will carry on. You often want to check that methods are being called with the correct args. You can constrain what args a mock will accept by calling `with`.

```ruby
	movie = double('Movie')
	
	# you can use `expect` or `allow`
	expect(movie).to receive(:fetch).with('Hail Caesar!')
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Movie">.fetch("Hail Caesar!")> 
  movie.fetch
  #=> RSpec::Mocks::MockExpectationError: #<Double "Movie"> received :fetch with unexpected arguments
  #=>  expected: ("Hail Caesar!")
  #=>       got: (no args)
 	
 	movie.fetch('x-men')
 	#=> RSpec::Mocks::MockExpectationError: #<Double "Movie"> received :fetch with unexpected arguments
  #=>   expected: ("Hail Caesar!")
  #=>        got: ("x-men")
	
	movie.fetch('Hail Caesar!')
	#=> nil
 
  expect(movie).to receive(:fetch).with(/Hail Caesar!/)
  expect(movie).to receive(:fetch).with('Hail Caesar!', 5)
```
 
When a method takes several arguments, you may want to place a constraint on one or some of them. Use the `anything` placeholder for any args you do not wish to constrain. You still need to pass the same number of arguments in'

```ruby
	contact = double('Contact')
	expect(contact).to receive(:add_details).with('John Smith', anything, anything)
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Contact">.add_details("John Smith", anything, anything)> 
  
  contact.add_details('John Smith')
	#=> RSpec::Mocks::MockExpectationError: #<Double "Contact"> received :add_details with unexpected arguments
  #=>  expected: ("John Smith", anything, anything)
  #=>       got: ("John Smith") 
  
  contact.add_details('Marge Smith', 'the town', '123456')
 	#=> RSpec::Mocks::MockExpectationError: #<Double "Contact"> received :add_details with unexpected arguments
  #=>   expected: ("John Smith", anything, anything)
  #=>        got: ("Marge Smith", "the town", "123456")

  contact.add_details('John Smith', 'the town', '123456')
  #=> nil 
```

Where you have a sequence of `anything` placeholders, you can replace them with `any_args` 

```ruby
	expect(movie).to receive(:add_rating).with('Hail Caesar', any_args)
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Movie">.add_rating("Hail Caesar", *(any args))> 
  
  movie.add_rating('Hail Caesar', 5)
	#=> nil
  movie.add_rating('Hail Caesar') # pass 0 or more args
  #=> nil
  movie.add_rating('Hail Maximus', 5)
  #=> RSpec::Mocks::MockExpectationError: #<Double "Movie"> received :add_rating with unexpected arguments
   #=>   expected: ("Hail Caesar", *(any args))
   #=>       got: ("Hail Maximus", 5)
```

`any_args` operates like the 'splat', `*`, operator in Ruby.

Alternately you can use `no_args`, ensures that no args can be passed to the method

```ruby
	expect(movie).to receive(:get_review).with(no_args).and_return('Loved it!')
	#=> #<RSpec::Mocks::MessageExpectation #<Double "Movie">.get_review(no arguments)> 
 
  movie.get_review
	#=> "Loved it!" 
  
  movie.get_review('Hail Caesar!')
  #=> RSpec::Mocks::MockExpectationError: #<Double "Movie"> received :get_review with unexpected arguments
  #=>  expected: (no args)
  #=>       got: ("Hail Caesar!")
```

You can use RSpec's `hash_including` to specify which keys must be present when dealing with methods that use an options hash of key/value pairs, especially APIs. Specify only the keys which are important.

```ruby
	class BoxOffice
		def find_showtime(options)
		  
		end
	end
	
	box_office = BoxOffice.new

	expect(box_office).to receive(:find_showtime).with(hash_including(movie: 'Jaws'))
	
	box_office.find_showtime(movie: 'Jaws')
	#=> nil
	box_office.find_showtime(movie: 'Jaws', director: 'Steven Speilberg')
	#=> nil
	box_office.find_showtime(director: 'Steven Speilberg')
	#=> RSpec::Mocks::MockExpectationError: #<BoxOffice:0x00000000026ffca0> received :find_showtime with unexpected arguments
  #=>  expected: (hash_including(:movie=>"Jaws"))
  #=>       got: ({:director=>"Steven Speilberg"})
```

`hash_including` specifies the keys that must be present. You can also use `hash_excluding` to specify keys that should NOT be present.

`hash_including` also works with Ruby's keyword arguments:

```ruby
	class BoxOffice
     def find_movie(title:, director: nil, year: nil)
     end  
  end
```

3. Setting constraints on the number of times and the order in which a method gets called

You can also set a constraint on the number of times a method gets called.
RSpec provides a number  of modifiers, e.g. `once`, `twice`, `thrice`. You can not combine `at_least` and `at_most`.


```ruby
	client = double('NYTStockTicker')
	
	expect​(client).to receive(​:current_price​).exactly(4).times
	expect​(client).to receive(​:current_price​).twice.and_raise(Timeout::Error)
	expect​(client).to receive(​:current_price​).at_least(3).times
	​expect​(client).to receive(​:current_price​).at_most(10).times
	expect​(client).to receive(​:current_price​).at_least(​:once​)
	
	expect​(client).to receive(​:current_price​).at_most(​:twice).and_return('$120.0')
	client.current_price
	#=> '$120'
	client.current_price
	#=> '$120'
	client.current_price
	#=> RSpec::Mocks::MockExpectationError: (Double "NYTStockTicker").current_price(no args)
  #=>    expected: at most 2 times with any arguments
  #=>    received: 3 times
```

Ordinarily you can call methods in any order, you don't have to call methods in the order the expectations are written. To enforce a specific order, use the `ordered` modifier.

```ruby
	greeter = double('Greeter')
	​expect​(greeter).to receive(​:hello​).ordered
	expect​(greeter).to receive(​:goodbye​).ordered
	
	# will fail
  greeter.goodbye
  greeter.hello 
```

You can combine arguments, call count and ordering:

```ruby
	catalog = double('Catalog')
	expect​(catalog).to receive(​:search​).with(​/term/​).at_least(​:twice​).ordered
```