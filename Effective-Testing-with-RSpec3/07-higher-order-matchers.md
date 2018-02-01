## Higher Order Matchers

RSpec has six different matchers which it uses to check strings and collections:

**include** 
		- check that an item(s) is(are) present(the string, collection can contain unrelated items)
		- works on strings, arrays and hashes(check for the presence of certain keys or key-value pairs)
		- accepts a variable number of arguments so thatyou can specify multiple substrings, array items, hash keys or key-value pairs
		

```ruby
	hash = {name: 'Harry Potter', age: 7, house: 'Mansion on the Hill'}
	expect(hash).to include(:name)
	expect(hash).to include(age: 7, name: 'Harry Potter')
	
	​expect​(​'a string').to include('str', 'ing')
	expect([1,2,3,4]).to include(3,2)
	
	# Note:
  arr = [3,2]
  expect([1,2,3,4,5]).to include(arr) #=> fails
  
  # pass in arr as individual items using '*'
  expect([1,2,3,4,5]).to include(*arr) 
```


**start_with** and **end_with**
 		- require that items be at the start or end
		- check for the sequence that a string collection stats or ends with

```ruby
	expect('a string').to start_with('a str').and end_with('ng')
	expect([1,2,3,4]).to start_with(1).and end_with(4)
	expect(1,2,3,4,5,6).to start_with(1,2).and end_with(5,6)
```


**all**
		- check that a property is common across all items
		- always takes another matcher as an argument
		- it expects all items in the collection/string to 'pass' - checks each in turn

```ruby
	numbers = [2,4,6,8,10,12]
	expect(numbers).to all be_even #=> be_even is a dynamic predicate
```


**match** 
		- checks a data structure against a pattern
		- match requires a specific order
		- useful for looking for patterns within a string(match against a string or regex pattern)
		- useful when calling a JSON/XML api which returns a deeply nested array or hash  

```ruby
	expect('a string of characters').to match(/str/)
	expect('a string of characters').to match('str')
	
	people = [{name: 'john', age: 23}, {name: '', age: 54}, {}]
	expect(people).to match([{name: 'john', age: a_value > 20}, {name: 'mike', age: a_value_between(40, 60)}, {}])
```


**contain_exactly** 
		- requires certain items to be present(in any order) and no others
		- can be used just like 'match', whereas with 'match' the order matters, with 'contain_exactly' it does not


**have_attributes**
		- check that an object has certain attributes, e.g hashes, structs, openstructs and active record instances
		
```ruby
	require 'uri'
	
	uri = URI('http:://github.com/rspec/spec')
	expect(uri).to have_attributes(host: 'github.com', path: 'rspec/spec')
```


### Higher order matchers and their aliases

```markdown
		
	**Strings and Collections**
	
	| Matcher        						| Passes If	           		 																			 | Available aliases  												|
	| ------------------------  |:--------------------------------------------------------------:| ------------------------------------------:|
	| contain_exactly(2, 1, 3)	| a.sort == [2, 1, 3].sort   																		 | match_array([2, 1, 3])											|
	| 					     						| 												  																		 | a_collection_containing_exactly(2, 1, 3)		|
	| start_with(x, y)			    | a[0] == x && a[1] == y																			   | a_collection_starting_with(x, y)						|
	| 					     						| 												  																		 | a_string_starting_with(x, y)								|
	| end_with(x, y)		     		| a[-1] == x && a[-2] == y					 													   | a_collection_ending_with(x, y)							|
	| 					     						| 												   																		 | a_string_ending_with(x, y)									|
	| include(x, y)					    | (a.include?(x) && a.include?(y)) || (a.key?(x) && a.key?(y))   | a_collection_including(x, y)								|
	| 					     						| 												   																		 | a_string_including(x, y)					 					|
	| 					    						| 												   																	 	 | a_hash_including(x, y)											|
	| include(w: x, y: z)	      | a[:w] == :x && a[:y] == :z				  													 | a_hash_including(w: x, y: z)								|
	| all(matcher)					    | a.all? { |e| matcher.matches?(e) }													   | 																						|
	| match(x: matcher, y: 3)		| matcher.matches?(a[:x]) && a[:y] == 3			   									 | an_object_matching(x: matcher, y: 3)				|
	| match([3, matcher])				| a[0] == 3 && matcher.matches?(a[1])												   	 | an_object_matching([3, matcher]) 					|
	| match("pattern")					| a.match("pattern")												   									 | a_string_matching("pattern") 							|
	| match(/regex/)					  | a.match(/regex/)												   										 | match_regex(/regex/)												|
	| 					     						| 																	 														 | a_string_matching(/regex/)									|
	
```

