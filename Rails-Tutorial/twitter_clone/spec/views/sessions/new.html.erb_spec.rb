require 'rails_helper'

RSpec.describe "sessions/new.html.erb", type: :view do

  describe "login", type: :feature do
    before(:each){visit login_path}

    it "has a signup form that posts to 'login' and accepts an email and password" do
      expect(page).to have_selector('form[action="/login"]')
      expect(page).to have_field('session_email')
      expect(page).to have_field('session_password')
    end

    it "has a 'Sign up now!' link that redirects users to the signup page" do
      click_link 'Sign up now!'

      expect(page.body).to include(full_title('Signup'))
      expect(page.body).to have_selector('form[action="/signup"]')
    end

  end
end
