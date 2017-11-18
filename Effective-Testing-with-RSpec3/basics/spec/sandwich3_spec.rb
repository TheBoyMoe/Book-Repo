RSpec.describe 'An ideal sandwich' do
  Sandwich = Struct.new(:taste, :toppings)

  # HELPER METHOD
  def sandwich
    # use 'memoization' to store the results of the operation, so we don't have to repeat the instantiation - MUST be an instance variable
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
