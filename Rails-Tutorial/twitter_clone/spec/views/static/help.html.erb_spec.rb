require 'rails_helper'

RSpec.describe "static/help.html.erb", type: :view do

  describe "GET '/help'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit help_path
    end

    it "has a title with the text 'Help | Twitter Clone App'" do
      expect(page.body).to have_title("Help | #{@base_title}")
    end

    it "has the content 'Help Page'" do
      expect(page.body).to have_content('Help Page')
    end
  end

end
