RSpec.describe 'An ideal sandwich' do
  Sandwich = Struct.new(:taste, :toppings)

  # HOOKS
  # - run auotomatically at specific times, e,g
	#   'before(:each)/before' runs before each example
  #   'before(:all)' runs ONCE before all tests in the group
  # - used to run common setup
  # - adds to setup time req'd to execute each test
  # - requires changing examples where instance variables are involved
  before {
		# needs to be an instance variable, otherwise each it do ..end block will
		# see their version of 'sandwich' as an undefined local variable
    @sandwich = Sandwich.new('delicious', [])
  }

  it "is delicious" do
    taste = @sandwich.taste

    expect(taste).to eq('delicious')
  end

  it "lets me add toppings" do
    @sandwich.toppings << 'cheese'
    toppings = @sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
