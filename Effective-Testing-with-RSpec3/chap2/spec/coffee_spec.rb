require_relative '../spec_helper'
require 'coffee'

=begin
  # executing rspec tests

  $ rspec /spec # run all tests in spec folder

  $ rspec /spec/users /spec/posts # run tests in /users and /posts folders

  $ rspec /spec/views/index_spec.rb /rspec/views/show_spec.rb # test 2 or more individual files

  $ rspec /spec/views /spec/controllers/posts_controller.rb # mix and match files & folders

  $ rspec --example milk # runs every test with the word 'milk' in the description (use --example or -e)
      e.g. 'A cup of coffee with milk costs $1.25' - rspec searches the full description

  $ rspec /spec/posts_controller.rb:25 # run specific example/group

  $ rpsec --only-failures # runs only tests that failed last run - rspec requires file in which rspec saves info about failing tests - set through rspec config in spec_helper.

=end

RSpec.describe 'A cup of coffee' do
  let(:coffee){Coffee.new}

  it "costs $1.00" do
    expect(coffee.price).to eq(1.0)
  end

  context 'with milk' do
    before{coffee.add :milk}

    it "costs $1.25" do
      expect(coffee.price).to eq(1.25)
    end

    # NOTES:
    # use 'context' when modifying the object being tested

    # to run a 'focused' example/group, add 'f' to 'it/describe/context' -> 'fit/fdescribe/fcontext'
    #     => only the example/group is run

    # to mark an example/group as pending and skip execuption, add 'x' to 'it/describe/context' -> 'xit/xdescribe/xcontext'
    #     => you can also add the word 'pending' or 'skip' anywhere inside the method body (any code before 'pending' will still run)
    #     => add a description, e.g `pending 'test not yet implemented'`, `skip 'Test not yet implemented'`
    #     => any test with a description, but no body is marked as pending

    it "is light in color" do
      # pending 'Color not yet implemented' # runs the test, results expected to fail. Any passing tests are marked as failures
      # skip 'Not yet implemented' # doesn't run the test
      expect(coffee.color).to eq(:light)
    end

    it "is cooler than 200 degrees Farenheit" do
      # pending "Temperature no yet implemented"
      expect(coffee.temperature).to be < 200.0
    end

  end

end
