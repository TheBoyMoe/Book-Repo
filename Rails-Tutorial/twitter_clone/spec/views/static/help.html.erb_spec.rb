require 'rails_helper'

RSpec.describe "static/help.html.erb", type: :view do

  describe "GET 'static/help'", :type => :feature do
    before(:each) do
      @base_title = 'Twitter Clone App'
      visit '/static/help'
    end

    it "has a title tag with the text 'Help | Twitter Clone App' and a page title" do
      expect(page.body).to include("<title>Help | #{@base_title}</title>")
      find('h1', text: 'Help Page')
    end
  end

end
