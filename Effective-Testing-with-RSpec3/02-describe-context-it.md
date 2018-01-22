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

