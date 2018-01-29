## Sharing logic


There a three main ways in RSpec
- using the 'let' keyword - lazy evaluation, ideal for setting up objects
- a 'hook', e.g. 'before' block
- and a helper method


```ruby
	module ExpenseTracker
		RSpec.describe 'POST a successful expense' do
			# let definitions
			let(:ledger)  { instance_double('ExpenseTracker::Ledger') }
			let(:expense) { { 'some' => 'data' } }
	
			# hook
			before do
				allow(ledger).to receive(:record)
					.with(expense)
					.and_return(RecordResult.new(true, 417, nil))
			end
	
			# helper method
			def parsed_last_response
				JSON.parse(last_response.body)
			end
	
		end
	end
```


### Hooks

Use a hook when 'let' isn't enough, e.g, you need to modify configuration, write to a file, etc.
You need to take into account 'type' - when the hook runs in relation to the example, and 'scope' - how often the hook runs.

#### Type

- before - runs before the example 
- after - runs after the example, even if an exception is raised. After hooks are intended to clean up after your setup and specs.

It's recommended using a 'before' hook for database cleanup.

```ruby
	RSpec.describe MyApp::Configuration do
		before(:example) do
			@original_env = ENV.to_hash
		end
		
		after(:example) do
			ENV.replace(@original_env)
		end
	end
```

- around - includes both setup and cleanup/teardown code in the same block. Setup runs before the example, teardown after, e.g.

```ruby
RSpec.describe MyApp::Configuration do
		
		 around(:example) do |ex|
			@original_env = ENV.to_hash
			ex.run
			ENV.replace(@original_env)
		end
		
	end
```

If you need your hooks to run for all examples across multiple groups you can place them in the `RSpec.config` block in `spec_helper.rb`.


#### Scope

Rspec has three scopes, `:example` (`:each`), `:context` (`:all`) and `:suite`. `:each` and `:all` are the old terms which have been replaced in Rspec 3.
 
By default RSpec sets the scope of your hooks to `:example` - run once before each example. Means that any example can be run on it's own and in any order. You can modify the scope to run the hook once for the entire suite, or example group with the `:suite` and `:context` arguments respectively. 

The `:context` scope runs once before the top-level example group. When you use a `:context` hook, you’re responsible for  cleaning up any resulting state—otherwise, it can cause other specs to pass or fail incorrectly. This is a particularly common problem with database code. Any records created in a before(:context) hook will not run in  your per-example database transactions. The records will stick around after the example group completes, potentially affecting later specs.


```ruby
	RSpec.describe ​'Web interface to my thermostat' do
	   ​before​(​:context​) do
     	 WebBrowser.launch​ 
	   end
     ​
		 ​after​(​:context​) do
		   WebBrowser.shutdown​
		 end
	end
```

The `:suite` is only allowed in the `RSpec.config` block, so is perfect for running setup code that only needs to run once, e.g.

```ruby
	# spec/rpec_helper.rb
  RSPec.config do |config|
  	config.before(:suite) do
  		#remove leftover tmp files
 			FileUtile.rm_rf('tmp') 
		end
   
	end
```


### Helper Methods

Helper methods are useful when we need to run some setup code for a specific example, or where using `let` and /or before hooks would result in a spec that was difficult to read. You can write your helper methods in a module and then include them in your example groups when you ned to use your helpers in more than one example group.


```ruby
module APIHelpers
	include Rack::Test::Methods
	
	def app
		ExpenseTracker::Api.new
	end

end


RSpec.describe 'Expense Tracker Api', :db do
	include APIHelpers
		
	#....
end
```

Where you need to include the same module in many or all your specs, you can do it via the `RSpec.config` block in `spec_helper.rb`.

```ruby
RSpec.config do |config|

	config.include APIHelpers
end
```