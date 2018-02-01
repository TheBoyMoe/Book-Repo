## Primitive/Value Matchers Cheat Sheet

```markdown

	**basic expression**
	
  expect​(a).to matcher
  
  **negate a matcher**
  
  expect​(a).not_to matcher
  expect​(a).to_not matcher
  
  **equality/identity**
  
  eq uses the == operator (uses Ruby's eq?)
  equal uses === operator (uses Ruby's equal?)
  eql used to check for hash equality (Uses Ruby's eql?)
	 
	| Matcher        | Passes If	           | Available aliases  						|
	| -------------  |:---------------------:| ------------------------------:|
	| eq(x)    		   | a == x   				     | an_object_eq_to(x)							|
	| eql(x)		     | a.eql?(x)			       | an_object_eql_to(x)				  	|
	| equal(x)       | a.equal?(x)		       | be(x) or an_object_equal_to(x)	|
	
	
	**Truthiness and nil**
	
	In Ruby nil and false are both treated as false, everything else is true
	
  | Matcher        | Passes If	           		 | Available aliases  				|
	| -------------  |:-------------------------:| --------------------------:|
	| be_truthy    	 | a != nil && a != false    | a_truthy_value							|
	| be true		     | a == true			     		   | 												  	|
	| be_falsey      | a == nil || a == false    | be_falsy 									|
	| 					     | 												   | a_falsey_value							|
	| 					     | 												   | a_falsy_value							|
	| be false	     | a == false							   | 														|
	| be_nil		     | a.nil?									   | a_nil_value 								|
	
	
	**Type matchers**
	
	| Matcher 						      | Passes If	        		 | Available aliases  				|
  | ------------------------  |:----------------------:| --------------------------:|
  | be_an_instance_of(klass)	| a.class == klass		   | be_instance_of(klass				|
  | 					  						  | 										   | an_instance_of(klass				|
  | be_a_kind_of(klass) 	    | a.is_a?(klass) 			   | be_a(klass)								|
  | 					   						  | 										   | be_kind_of(klass)					|
  | 					   						  | 										   | a_kind_of(klass)						|
  
  
  **Operator Comparisons**
  
  | Matcher        | Passes If	           		 | Available aliases  				|
	| -------------  |:-------------------------:| --------------------------:|
	| be == x		     | a == x									   | a_value == x								|
	| be < x		     | a < x									   | a_value < x								|
	| be > x		     | a > x									   | a_value > x								|
	| be <= x				 | a <= x									   | a_value <= x								|
	| be >= x			   | a >= x									   | a_value >= x								|
	| be =~ x			   | a =~ x									   | a_value =~ x								|
	| be === x	     | a === x								   | a_value === x							|
    
    
	**Delta/Range Comparrisons**
	
	 Because binary's representation of floats is imperfect, use be_within matcher
	 The value passed to be_within is the 'delta' or absolute difference in either direction
	 To express a range use be_between 
    
  | Matcher 								      | Passes If	            		 | Available aliases  							|
	| ----------------------------  |:--------------------------:| --------------------------------:|
	| be_between(1,10).inclusive    | a >= 1 && a <= 10	 			   | be_between(1,10)									|
	| 					     								| 													 | a_value_between(1,10).inclusive	|
	| 					     								| 												   | a_value_between(1,10)						|
	| be_between(1,10).exclusive    | a > 1 && a < 10		  			 | a_value_between(1,10).exclusive	|
	| be_within(0.1).of(x)   	      | (a - x).abs <= 0.1   			 | a_value_within(0.1).of(x)				|
	| be_within(5).percent_of(x)    | (a - x).abs <= (0.05 * x)  | a_value_within(5).percent_of(x)	|
	| cover(x,y)		 					      | a.cover?(x) && a.cover?(y) | a_range_covering(x,y)						|
	
	
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
	
	
	**Duck Typing and Attributes**
	
	| Matcher        										 | Passes If	       											    		| Available aliases  												|
  | ---------------------------------  |:----------------------------------------------:| -----------------------------------------:|
  |	have_attributes(w: x, y: z)				 | a.w == x && a.y == z									 					| an_object_having_attributes(w: x, y: z)		|
  |	respond_to(:x, :y)							   | a.respond_to?(:x) && a.respond_to?(:y)					| an_object_responding_to(:x, :y)						|
  |	respond_to(:x).with(2).arguments	 | a.respond_to?(:x) && a.method(:x).arity == 2		| an_object_responding_to(:x, :y)						|
  
  
  **Dynamic Predicates**
  
  A predicate is a method that 'answers a question' with a boolean.
  
  | Matcher        				 | Passes If	           		 							 | Available aliases  				|
	| ---------------------  |:---------------------------------------:| --------------------------:|
	|	be_xyz								 | a.xyz? || a.xyzs?											 | be_a_xyz 									|
	|								 				 |																				 | be_an_xyz									|
	|	be_foo(x, y, &b)			 | a.foo(x, y, &b)? || a.foos(x, y, &b)?	 | be_a_foo(x, y, &b)					|
	|												 |													 							 | be_an_foo(x, y, &b)				|
 	|	have_xyz							 | a.has_xyz?													 		 |														|
 	|	have_foo(x, y, &b)		 | a.has_foo(x, y, &b)?										 |														|
  
    
    
  **Additional Matchers**  
    
	| Matcher       									 | Passes If						          		| Available aliases  												|
	| -------------------------------  |:----------------------------------:| -----------------------------------------:|
	|	exist							 							 | a.exist? || a.exists? 							| an_object_existing												|
	| exist(x, y)								 			 | a.exist(x, y)? || a.exists(x, y)?	| an_object_existing(x, y)									|
	|	satisfy { |x| ... }							 | Provided block returns true				| an_object_satisfying { |x| ... }					|
	|	satisfy("criteria") { |x| ... }	 | Provided block returns true				| an_object_satisfying("...") { |x| ... }		|
	
	
```
