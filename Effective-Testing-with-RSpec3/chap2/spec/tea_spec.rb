require_relative '../spec_helper'
require 'tea'

RSpec.describe Tea do

  let(:tea){Tea.new}

  it "tastes like Earl Grey" do
    expect(tea.flavour).to eq(:earl_grey)
  end

  it "is hot" do
    expect(tea.temperature).to be > 200.0
  end
end
