RSpec.describe 'An ideal sandwich' do
  Sandwich = Struct.new(:taste, :toppings)


  # HOOKS
  # - run auotomatically at specific times, e,g 'before' hook which will run before each example
  # - used to run common setup
  # - adds to setup time req'd to execute each test
  # - requires changing examples where instance variables are involved
  before {
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
