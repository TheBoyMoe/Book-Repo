## Custom Matchers

All the matchers so far covered ship with RSpec and deal with general purpose Ruby. There are occasions when you will want to create your own matchers to better express the behaviour your testing and provide more descriptive error messages providing additional detail about what is actually being tested.

```ruby
	expect(art_show).to have_no_tickets_sold
	expect(concert).to be_sold_out
```

1. One technique is to define your own methods(helper methods) which return the same objects that built in RSpec matchers check for, e.g combine RSpec's 'contain_exactly' with with the helper method 'a_hash_including'.


```ruby
	# using built in matchers
	expect(ledger.expenses_on('2017-06-10')).to contain_exactly(a_hash_including(id: result_1.expense_id))
	
	# using a helper method
  expect(ledger.expenses_on('2017-06-10')).to contain_exactly(an_expense_identified_by(result_1.expense_id)) 
```

To implement this particular example, 'an_expense_identified_by' helper
 - ensure that the method delegates to 'a_hash_including'
 - make the helper available to all your specs by defining it within a module inside 'spec/spec_helper.rb'


```ruby
	# spec/spec_helper.rb
  
	module ExpenseTrackerMatchers
		def an_expense_identified_by(id)
			# ensure that you're only checking for exepnse hashes by checking for other keys
			a_hash_including(id: id).and including(:payee, :amount)
		end 
	end
	
	RSpec.config do |config|
	
		config.include ExpenseTrackerMatchers
		# .....
		 
	end
```


2. Define aliases for built in RSpec matchers

General form:

```ruby
	RSpec::Matchers.alias_matcher :new_method, :existing_matcher
```

You can also use this technique to create your own negated matchers

General form:

```markdown
	RSpec::Matchers.define_negated_matcher :new_method, :existing_matcher
	
	# example
	expect​(correct_grammar).to_not split_infinitives
	# becomes
	expect​(correct_grammar).to avoid_splitting_infinitives
	# by
	RSpec::Matchers.define_negated_matcher ​:avoid_splitting_infinitives, :split_infinitives
```

3. Define a matcher using RSpec's domain-specific language(DSL)

4. Define a Ruby class as a matcher, it just needs to implement the 'matcher protocol'