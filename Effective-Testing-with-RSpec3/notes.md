## Running RSpec command

[Agile Ventures RSpec Mob C9 instnce](https://ide.c9.io/tansaku/agile-ventures-mob)
[Agile Ventures mob videos](https://www.youtube.com/playlist?list=PLuyBZ95Nkc4bpwbzOTAkHy1Sj-kFNsdom)
[Rspec 3 Book Code](https://github.com/rspec-3-book) 

```bash
$ rspec /spec # run all tests in spec folder

$ rspec /spec/users /spec/posts # run tests in /users and /posts folders

$ rspec /spec/views/index_spec.rb /rspec/views/show_spec.rb # test 2 or more individual files

$ rspec /spec/views /spec/controllers/posts_controller.rb # mix and match files & folders

$ rspec --example milk # runs every test with the word 'milk' in the description (use --example or -e)
    e.g. 'A cup of coffee with milk costs $1.25' - rspec searches the full description

$ rspec /spec/posts_controller.rb:25 # run specific example/group

$ rpsec --only-failures # runs only tests that failed last run
  #=> run `rspec` first to record all failing tests
  #=> run `rspec --only-failures` on subsequent runs
  #=> requires that the `config.example_status_persistence_file_path` option is set in `spec_helper`
  #=> rspec requires txt file in which it saves info about failing tests.

$ rspec --next-failure # runs the next failing test
  #=> run `rspec` first to record all failures
  #=> run `rspec --next-failure` to display the next failing test.
  #=> requires that the `config.example_status_persistence_file_path` option is set in `spec_helper`

$ rspec --fail-fast
  #=> runs all tests, stopping at the first failing test
```


NOTES:

  * use 'context' when modifying the object being tested

  * to run a 'focused' example/group, add 'f' to 'it/describe/context' -> 'fit/fdescribe/fcontext'
     => only the example/group is run

  * to mark an example/group as pending and skip execuption, add 'x' to 'it/describe/context' -> 'xit/xdescribe/xcontext'

  * you can also add the word 'pending' or 'skip' anywhere inside the method body (any code before 'pending' will still run)
    * add a description, e.g `pending 'test not yet implemented'`, `skip 'Test not yet implemented'`

  * you can also mark groups/examples with `:pending => true`, e.g., so disabling a whole group or individual test. 

  ```ruby
    context 'invalid', :pending => true do
     before :each do
       @game = HangpersonGame.new('foobar')
     end
     it 'throws an error when empty', :pending => true do
       expect { @game.guess('') }.to raise_error(ArgumentError)
     end
    end
  ```


  * any test with a description, but no body is marked as pending

  * tests marked with the `pending` keyword are expected to fail and are still run - appear in yellow

  * passing tests which are marked `pending` will FAIL - and appear in red.

  * any test/group marked with `x` or `skip` are NOT run - marked as pending and appear in yellow


## Describe, context, it, example and specify


### describe 

- Allows to provide a logical structure to a series or related examples by creating a 'group'
- Provide a context to a particular class, module, method (requires that they exist) or situation that you're testing, e.g

```ruby
	RSpec.describe Perennials do
	end
	
	RSpec.describe Perennials::Rhubarb do 
	end
	
	RPsec.describe my_favorite_broccoli do
	end
	
	RSpec.describe '#my_favorite_broccoli' do
	end
	
	RSpec.describe 'My gardening API' do
	end
```

You can combine a class/module/object with a string, e.g.

```ruby
	RSpec.describe Perennials, 'in winter' do
  end
```

You can also combine these with metadata, and add a tag, e.g.

```ruby
	RSpec.describe Perennials, 'in winter', uses_network: true do
  end
```


### it

Creates one example, pass it a description of the behaviour your testing. You add metadata to tell RSpec to run the specific example differently, e.g.

```ruby
	RSpec.describe Perennials, 'in winter' do
  	it "grow quite slowly", usues_serial_bus: true do
  	end
  end
```


### context


Context is an alias for 'describe', provides a better way of 'wording' an example description - give a clearer indication of the intent behind the code. Used to group examples which share a common situation or condition.

```ruby
	RSpec.describe 'A kettle of water' do
	
		context 'when boiling' do
		
			it 'can make tea'
			
			it 'can make coffee'
		end
	end
```

### example

Example is an alias for 'it'. Works just like 'it', but in certain situations reads more clearly, e.g. where it does not make sense having a phrase atart with 'it'

```ruby
RSpec.describe PhoneNumberParser, 'parses phone numbers' do

	​it​ ​'in xxx-xxx-xxxx form'​
	​it​ ​'in (xxx) xxx-xxxx form'​
	
	# becomes
	example ​'in xxx-xxx-xxxx form'​
  example ​'in (xxx) xxx-xxxx form'​
end
```

### specify

Another alias for 'it', used when neither 'it' or 'example' reads well, e.g.

```ruby
RSpec.describe ​'Deprecations' do
​	specify​ ​'MyGem.config is deprecated in favor of MyGem.configure'​
end
```


RSpec also allows you to define your own names for 'describe' and 'it'



