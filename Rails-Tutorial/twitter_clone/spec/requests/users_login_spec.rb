require 'rails_helper'

RSpec.describe "UsersLogin", type: :request do
  describe "GET /login" do
    before(:each){
      visit login_path
      fill_in 'session_email', with: '   '
      fill_in 'session_password', with: '   '
      click_button 'Log in'
    }

    context "with invalid information", type: :feature do

      it "returns a flash message" do
        expect(page.body).to have_selector('form[action="/login"]')
        expect(page.body).to have_selector('div.alert.alert-danger')
      end

      it "should remove the message if the user visits another page" do
        click_link 'Home'

        expect(page.body).to have_title(full_title('Home'))
        expect(page.body).not_to have_selector('div.alert.alert-danger')
      end
    end
  end
end
