require_relative '../spec_helper'
require 'coffee'

=begin

  NOTE:

  1. use the 'coderay' gem to add syntax highlighting to the cli
  (in bundler projects add coderay to your gem, otherwise install it using 'gem install coderay')

  2. to identify slow running tests use the --profile option, e.g.

  $ rspec spec/test_spec.rb --profile

  3.
  you can run tests by directory - all files/test executed
  you can run tests by file - all tests in the file run
  you can run tests by line number
  you can run tests by name using the -e option with a search term, e.g.

  $ rspec spec -e milk
    #=> run all examples in the spec folder which include the term 'milk'
    #=> Rspec searches the full description, 'A cup of coffee with milk'
    #=> searches are case sensitive

  4. you can run only failures with the '--only-failures' option, e.g.
    $ rspec --only-failures
      #=> run the rspec normally the first time(with out the option) to find and record all the failures
      #=> on subsequent runs add the option so as to exclude all passing and skipped tests
      #=> 'pending' tests are still executed - marked as failed
      #=> you need to define a path where Rspec can save the resulting data:

        Configure the spec_helper file

        RSpec.configure do |config|
          config.example_status_persistence_file_path = ​'path/to/file.txt'​
        end

  5. you can execute the next failure only with the '--next-failure' option
  $ rspec spec/ --next-failure
    #=> run rspec normally first time, add the option to subsequent runs
    #=> stops execution at the first failure

     similar to the '--fail-fast' option which stops at the first failure
      - does not require spec_helper configuration

  6. you can focus on an example or a group by adding 'f' to the beginning of the method name, e.g
    'it', 'context', 'describe' becomes 'fit', 'fcontext' and 'fdescribe',
     run rspec(no options required) only that example/group are executed

     You need to configure the spec_helper file

      RSpec.configure ​do​ |config|
         config.filter_run_when_matching(​focus: ​​true​)​
      end


  7. empty examples:
    - just the 'it' statement
    - displayed in yellow with an astrix
    - marked as pending

  8. pending examples:
    - use the 'pending' keyword, with an explanation(optional)
    - rspec treats them as failing tests
    - use for tests expected to fail - displayed in red as failed
    - lines appearing afterwards are not run

  9. skipped examples:
    - to skip 'it', 'describe' or 'context'
      - use the 'skip' keyword (with an optional  explanation), or add 'x' in front of the method, e.g.
      - 'xit', 'xcontext' , 'xcontext'
    - the example/group is skipped with the description & explanation displayed in yellow

=end


RSpec.describe 'A cup of coffee' do
  let(:coffee){Coffee.new}

  it "costs $1.00" do
    expect(coffee.price).to eq(1.0)
  end

  context 'with milk' do
    before{coffee.add :milk}

    it "costs $1.25" do
			# pending 'Not yet implemented'
			# skip 'Not yet implemented'
      expect(coffee.price).to eq(1.25)
    end

    it "is light in color" do
      # pending 'Color not yet implemented'
      # skip 'Not yet implemented'
      expect(coffee.color).to eq(:light)
    end

    it "is cooler than 200 degrees Farenheit" do
      pending "Temperature no yet implemented"
      # skip 'Not yet implemented'
      # expect(coffee.temperature)<.to be < 200.0
    end

  end

end
