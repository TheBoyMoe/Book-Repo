require 'rails_helper'

RSpec.describe "UsersIndex", type: :request do

  fixtures :all

  describe "GET /users", type: :feature do
    before(:each) {
      @user = users(:michael)
      visit login_path
      fill_in 'session_email', with: "michael@example.com"
      fill_in 'session_password', with: "password"
      click_button 'Log in'
      visit users_path
    }

    it "directs the user to the '/users' page" do
      expect(page.status_code).to eq(200)
    end

    it "displays list of users with pagination" do
      expect(page.body).to have_selector('div.pagination')
      User.paginate(page: 1).each do |user|
        expect(page.body).to have_selector('li', text: user.name)
      end
    end
  end
end
