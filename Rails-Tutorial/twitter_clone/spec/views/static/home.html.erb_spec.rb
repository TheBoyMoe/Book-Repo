require 'rails_helper'

RSpec.describe "static/home.html.erb", type: :view do

  describe "GET '/'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit '/'
    end

    it "has a title element with the text 'Home | Twitter Clone App' and a page heading" do
      expect(page.body).to include("<title>Home | #{@base_title}</title>")
    end
  end

  describe "GET 'static/home'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit '/static/home'
    end

    it "has a title element with the text 'Home | Twitter Clone App' and a page heading" do
      expect(page.body).to include("<title>Home | #{@base_title}</title>")
      find('h1', text: 'Sample App')
    end
  end

end
