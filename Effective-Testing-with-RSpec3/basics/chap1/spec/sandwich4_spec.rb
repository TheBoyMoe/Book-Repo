RSpec.describe 'An ideal sandwich' do
  Sandwich = Struct.new(:taste, :toppings)

  # the code block is bound to the name 'sandwich' and then run the first time
	# 'sandwich' is called, and then available there after
	# an improvement on the before{} which is run each time, even if not req'd for that example
  let(:sandwich){Sandwich.new('delicious', [])}

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
