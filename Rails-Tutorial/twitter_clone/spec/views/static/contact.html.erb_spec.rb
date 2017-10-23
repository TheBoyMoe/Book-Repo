require 'rails_helper'

RSpec.describe "static/contact.html.erb", type: :view do

  describe "GET '/contact'", :type => :feature do
    before(:each) do
      visit contact_path
    end

    it "has a title with the text 'Contact | Twitter Clone App'" do
      expect(page.body).to have_title(full_title('Contact'))
    end

    it "has the content 'Contact Page'" do
      expect(page.body).to have_content('Contact Page')
    end
  end

end
