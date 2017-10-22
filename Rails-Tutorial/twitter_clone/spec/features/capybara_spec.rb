require 'rails_helper'

describe "testing using capybara" do

  context "GET 'static/home'" do
    before(:each) {visit '/static/home'}

    it "has a title element with the text 'Home | Twitter Clone App'" do
      expect(page.body).to include("<title>Home | Twitter Clone App</title>")
      find('h1', text: 'Sample App')
    end
  end

  context "GET 'static/help'" do
    before(:each) {visit 'static/help'}

    it "has a title tag with the text 'Help | Twitter Clone App'" do
      expect(page.body).to include("<title>Help | Twitter Clone App</title>")
      find('h1', text: 'Help Page')
    end
  end

  context "GET 'static/help'" do
    before(:each) {visit 'static/about'}

    it "has a title tag with the text 'About | Twitter Clone App'" do
      expect(page.body).to include("<title>About | Twitter Clone App</title>")
      find('h1', text: 'About Page')
    end
  end
end
