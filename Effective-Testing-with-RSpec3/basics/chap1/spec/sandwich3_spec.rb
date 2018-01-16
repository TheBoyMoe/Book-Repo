require 'pry'
RSpec.describe 'An ideal sandwich' do
  Sandwich = Struct.new(:taste, :toppings)

	# NOTE:
	# One problem with memoization is if you make a call to a long running process
	# that is falsey, returns nil , e.g
	# @toaster ||= Toaster.find_by_serial('hj9uy654re')
	# This call will be repeated if the call returns nil each time
  # An alternative is to use let()

  # HELPER METHOD
	# more efficient than using a 'before' hook
  def sandwich
    # use 'memoization' to store the results of the operation and refer to the stored copy,
    # so we don't have to repeat the instantiation - MUST be an instance variable
    # otherwise the second example will fail since we call 'sandwich' twice
    # each time we call it we receive a different object
    @sandwich ||= Sandwich.new('delicious', [])
  end

  it "is delicious" do
    taste = sandwich.taste
    expect(taste).to eq('delicious')
  end

  it "lets me add toppings" do
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings
    expect(toppings).not_to be_empty
	end

  # Using 'memoization' we're NOT sharing the object between examples
	# Each call for '#sandwich' within a block is separate to other blocks
	it "lets me add additional toppings" do
    sandwich.toppings << "olives"
		expect(sandwich.toppings).to eq(['olives'])
		sandwich.toppings << "ham"
		expect(sandwich.toppings).to eq(['olives', 'ham'])
	end

end
