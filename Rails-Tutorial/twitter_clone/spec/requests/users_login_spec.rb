require 'rails_helper'

RSpec.describe "UsersLogin", type: :request do

  describe "user login" do
    before(:each){
      visit login_path
    }

    context "with invalid information", type: :feature do
      before(:each) {
        fill_in 'session_password', with: '   '
        fill_in 'session_email', with: '   '
        click_button 'Log in'
      }
      it "returns a flash message" do
        expect(page.body).to have_selector('form[action="/login"]')
        expect(page.body).to have_selector('div.alert.alert-danger')
      end

      it "displays the 'Log in' nav link, 'Log out' and 'Profile' links not available" do
        expect(page.body).to have_selector('li', text: 'Log in')
        expect(page.body).not_to have_selector('li', text: 'Profile')
        expect(page.body).not_to have_selector('li', text: 'Log out')
      end

      it "should remove the message if the user visits another page" do
        click_link 'Home'

        expect(page.body).to have_title(full_title('Home'))
        expect(page.body).not_to have_selector('div.alert.alert-danger')
      end
    end

    context "with valid information", type: :feature do

      before(:each) {
        @user = User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
        fill_in 'session_email', with: 'andrew@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'Log in'
      }

      it "redirects the user to their profile page" do
        # binding.pry
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{@user.id}")
        expect(page.body).to include('andrew')
      end

      it "displays the 'Log out' and 'Profile' links in the nav bar and removes the 'Login' link" do
        expect(page.body).to have_selector('li', text: 'Profile')
        expect(page.body).to have_selector('li', text: 'Log out')
        expect(page.body).not_to have_selector('li', text: 'Log in')
      end

      context "user logout" do
        it "redirects to user to the site 'root'" do
          click_link 'Log out'

          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq("/")
          expect(page.body).to include('Welcome to the Sample App')
        end

        it "displays the 'Login link', 'Log out' and 'Profile' removed" do
          click_link 'Log out'

          expect(page.body).to have_selector('li', text: 'Log in')
          expect(page.body).not_to have_selector('li', text: 'Profile')
          expect(page.body).not_to have_selector('li', text: 'Log out')
        end

      end
    end


  end
end