require 'rails_helper'

RSpec.describe "static/help.html.erb", type: :view do

  describe "GET '/help'", :type => :feature do
    before(:each) do
      visit help_path
    end

    it "has a title with the text 'Help | Twitter Clone App'" do
      expect(page.body).to have_title(full_title('Help'))
    end

    it "has the content 'Help Page'" do
      expect(page.body).to have_content('Help Page')
    end
  end

end
