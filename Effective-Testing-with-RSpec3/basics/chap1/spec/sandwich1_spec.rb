RSpec.describe 'An ideal sandwich' do # example group - set or related tests, defines what you're testing
  Sandwich = Struct.new(:taste, :toppings)

  # Inside the example, you follow the Arrange/Act/Assert pattern: set up an object, do something with it, and check that it behaved the way you wanted
  # document what the test should do, check that it does it.
  it "is delicious" do # example/test case/spec
		# document what should happen
    sandwich = Sandwich.new('delicious', []) # set up object/pre-condition
    taste = sandwich.taste # do something to it - ask it for 'taste'

		# check that it actually happened
    expect(taste).to eq('delicious') # verify the result - expected outcome
  end

  it "lets me add toppings" do
    sandwich = Sandwich.new('delicious', [])
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings

		# negate your expectation - check for a falsehood
    expect(toppings).not_to be_empty
  end
end
