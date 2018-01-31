## Expectations

Expectations are made up of a series of parts:

- a subject - the thing you’re testing, an instance of a Ruby class
- a matcher - an object that specifies what you expect to be true about the subject, and provides the pass/fail logic
- (optionally) A custom failure message, when the default failure message doesn’t provide enough detail

These parts are held together with `expect` and either `to` or `not_to/to_not`

[example expectation](expectation-parts.png)


RSpec generates an expectations object, which 'wraps' the subject, upon which we can call matcher methods, such as `to`, `to_not`, etc. The matcher, e.g. `eq`, checks that the subject satifies the criteria. Rspec ships with the `RSpec::Matchers` module which includes built in matchers.


### Matchers and their advantages over assertions:

- matchers are first-class objects that can be combined and used in flexible ways that simple assert methods can’t
- matchers can be automatically negated by passing them to `expect(object).not_to`
- expectations uses a syntax that, when read out loud, sounds like an English description of the outcome you expect.

- you can combine matchers with `and` or `or`

```ruby
	alphabet = (​'a'​..'z'​).to_a
	expect​(alphabet).to start_with('a').and end_with('z')
```

- you can pass one matcher to another, e.g. you expect a particular array to start with a value that’s near π. With RSpec, you can pass the `be_within(0.1).of(Math::PI)` matcher into the `start_with` matcher to specify this behavior.

```ruby
   numbers = [3.14159, 1.734, 4.273]
	expect​(numbers).to start_with( be_within(0.1).of(Math::PI) )
```

- matcher's are self-describing, they include the (optional) `description` method. Included in all built in matchers. The descriptions are used in failure messages, run your specs with the `--format documentation` option. Displays the description added to the individual spec and describe it's intended behaviour. They help identify duplicate specs.

Any Ruby object can be used as a matcher as long as it implements a minimal set of methods.
- RSpec expects every matcher to implement a `matches?` method, which takes an object and returns true if the object matches (and false otherwise).
- When the provided object does not match, RSpec calls the matcher’s `failure_message` method, which throws an `ExpectationNotMetError` and displays an appropriate message.
- `matches?` and `failure_message` are the only methods a simple matcher need to define.
- Matchers use Ruby's `===` method, case equality, defines a category to which other objects may(or may not) belong.


### RSpec's Matchers

Fall in to three broad groups:

*primitive matchers*
 
- check basic data types such as strings, numbers, booleans, etc
- do not accept other matchers as input, though you can pass them to higher-order matchers
- generally used to check equality and identity
- most of the time we're concerned with value equality, use `eq` which uses `==` operator
- when checking for identity, i.e. two references refer to the same underlying object, use `equal`, which uses Ruby's `equal?` operator

```ruby
	expect(first).to equal(second)
	
	# or you can use `be`, which is an alias for `equal`
 	expect(first).to be(second) 
```

- we can also check for hash key equality, check that two values should be considered the same hash key. Use `eql`, which uses Ruby's `eql?` operator.


```ruby
	# examples of other useful matchers
  expect(value).to be_truthy # in Ruby only 'nil' and 'false' are falsey
  expect(value).not_to be_truthy
 
  expect(value).to be_falsey
  expect(value).not_to be_falsey
  
  expect(value).to be == 1
  expect(value).to be > 1
  expect(value).to be < 1
  expect(value).to be >= 1
  expect(value).to be <= 1
  
```



*higher-order matchers*

- take other matchers as input



*block matchers*

- check the properties of code, e.g. blocks, exceptions and side effects


 
