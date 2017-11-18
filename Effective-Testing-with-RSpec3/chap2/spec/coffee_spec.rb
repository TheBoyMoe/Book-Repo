require_relative '../spec_helper'
require 'coffee'

=begin
  # executing rspec tests


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



    it "is light in color" do
      # pending 'Color not yet implemented'
      # skip 'Not yet implemented' 
      expect(coffee.color).to eq(:light)
    end

    it "is cooler than 200 degrees Farenheit" do
      # pending "Temperature no yet implemented"
      expect(coffee.temperature).to be < 200.0
    end

  end

end
