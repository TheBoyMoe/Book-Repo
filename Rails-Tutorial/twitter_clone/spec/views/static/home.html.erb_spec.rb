require 'rails_helper'

RSpec.describe "static/home.html.erb", type: :view do

  describe "GET '/'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit '/'
    end

    it "has a title element with the text 'Home | Twitter Clone App'" do
      expect(page.body).to have_title("Home | #{@base_title}")
    end

    it "has the content 'Welcome to the Sample App'" do
      expect(page.body).to have_content('Welcome to the Sample App')
    end
  end

end
