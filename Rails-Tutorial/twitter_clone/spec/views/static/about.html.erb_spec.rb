require 'rails_helper'

RSpec.describe "static/about.html.erb", type: :view do

  describe "GET 'static/about'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit '/static/about'
    end

    it "has a title tag with the text 'About | Twitter Clone App' and a page heading" do
      expect(page.body).to include("<title>About | #{@base_title}</title>")
      find('h1', text: 'About Page')
    end
  end

end
