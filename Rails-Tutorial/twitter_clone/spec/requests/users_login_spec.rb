require 'rails_helper'

RSpec.describe "UsersLogin", type: :request do

  fixtures :all

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
      let(:user) {users(:archer)}

      before(:each) {
        fill_in 'session_email', with: "#{user.email}"
        fill_in 'session_password', with: 'password'
        click_button 'Log in'
      }

      it "redirects the user to their profile page" do
        expect(page.status_code).to eq(200)
        expect(page.current_path).to eq("/users/#{user.id}")
        expect(page.body).to include("#{user.name}")
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

    # REVIEW: section 9.3.1 testing 'remember me' check box
    xcontext "persisting user session", type: :feature do
      before(:each){
        User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
        fill_in 'session_email', with: 'andrew@example.com'
        fill_in 'session_password', with: 'password'
      }

      it "saves a token to a persistent cookie when the 'remember_me' checkbox is selected" do
        # find(:css, '#session_remember_me').set(true)
        check('session_remember_me')
        click_button 'Log in'
        binding.pry
        expect(cookies['remember_token']).not_to be nil
      end

      it "does not save a token to a persistent cookie if the 'remember_me' checkbox is not selected" do
        uncheck('session_remember_me')
        click_button 'Log in'

        expect(cookies['remember_token']).to be nil
      end

      it "deletes the cookie when the user logs out" do
        check('session_remember_me')
        click_button 'Log in'
        click_link 'Log out'

        expect(cookies['remember_token']).to be nil
        # expect(cookies).to be_empty
      end

    end
  end
end
