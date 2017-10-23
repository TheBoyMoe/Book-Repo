require 'rails_helper'

RSpec.describe "static/contact.html.erb", type: :view do

  describe "GET '/contact'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit contact_path
    end

    it "has a title with the text 'Contact | Twitter Clone App'" do
      expect(page.body).to have_title("Contact | #{@base_title}")
    end

    it "has the content 'Contact Page'" do
      expect(page.body).to have_content('Contact Page')
    end
  end

end
