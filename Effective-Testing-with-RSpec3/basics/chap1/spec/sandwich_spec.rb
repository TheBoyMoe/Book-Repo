RSpec.describe 'An ideal sandwich' do # example group - set or related tests, defines what you're testing
  Sandwich = Struct.new(:taste, :toppings)

  # Inside the example, you follow the Arrange/Act/Assert pattern: set up an object, do something with it, and check that it behaved the way you wanted
  # document what the test should do, check that it does it.
  it "is delicious" do # example/test case/spec
    sandwich = Sandwich.new('delicious', []) # set up object
    taste = sandwich.taste # ask it for 'taste'

    expect(taste).to eq('delicious') # verify the result
  end

  it "lets me add toppings" do
    sandwich = Sandwich.new('delicious', [])
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
