require 'rails_helper'

RSpec.describe "static/about.html.erb", type: :view do

  describe "GET '/about'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit about_path
    end

    it "has a title with the text 'About | Twitter Clone App'" do
      expect(page.body).to have_title("About | #{@base_title}")
    end

    it "has the content 'About Page'" do
      expect(page.body).to have_content('About Page')
    end
  end

end
