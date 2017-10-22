require 'rails_helper'

RSpec.describe "static/contact.html.erb", type: :view do

  describe "GET 'static/contact'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit '/static/contact'
    end

    it "has a title tag with the text 'Contact | Twitter Clone App' and a page heading" do
      expect(page.body).to include("<title>Contact | #{@base_title}</title>")
      find('h1', text: 'Contact Page')
    end
  end

end
