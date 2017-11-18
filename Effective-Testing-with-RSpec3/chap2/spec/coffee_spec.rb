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

  # use 'context' when modifying the object being tested
  # to run a 'focused' example/group, add 'f' to 'it/describe/context' -> 'fit/fdescribe/fcontext'
  # => only the example/group is run
  fcontext 'with milk' do
    before{coffee.add :milk}

    it "costs $1.25" do
      expect(coffee.price).to eq(1.25)
    end
  end
end
