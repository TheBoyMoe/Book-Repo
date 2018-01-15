RSpec.describe 'An ideal sandwich' do
  Sandwich = Struct.new(:taste, :toppings)

  # HELPER METHOD
	# more efficient than using a 'before' hook
  def sandwich
    # use 'memoization' to store the results of the operation, so we don't
    # have to repeat the instantiation - MUST be an instance variable
    # otherwise the second example will fail since we call 'sandwich' twice
    # each time we call it we receive a different object
    # Using 'memoization' means we're sharing the object between examples
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
end
