require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "#full_title" do
    it "returns the full title if a page title is provided" do
      title = 'Home'
      expect(full_title(title)).to eq('Home | Twitter Clone App')
    end

    it "returns the basetitle if no page tile is provided" do
      title = ''
      expect(full_title(title)).to eq('Twitter Clone App')
    end
  end
end
