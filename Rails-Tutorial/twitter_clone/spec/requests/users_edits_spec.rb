require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do

  describe "profile edit", type: :feature do

    context "when a user is loged in" do

      before(:each) {
        @user = User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
        visit login_path
        fill_in 'session_email', with: 'andrew@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'Log in'
        click_link 'Settings'
      }

      context "renders edit page" do

        it "displays input fields populated with user name and email" do
          expect(page.status_code).to eq(200)
          expect(page.body).to have_selector('input[value="Andrew"]')
          expect(page.body).to have_selector('input[value="andrew@example.com"]')
        end
      end

      context "with invalid information" do
        before {
          fill_in 'user_name', with: '   '
          fill_in 'user_email', with: '  '
          fill_in 'user_password', with: '12345'
          fill_in 'user_password_confirmation', with: '12345678'
          click_button 'Save changes'
        }

        it "displays an error message" do
          expect(page.body).to have_selector('div.alert.alert-danger', text: "The form contains 5 errors.")
        end

      end

      context "with valid information" do
        before {
          fill_in 'user_name', with: 'Andrew Smith'
          fill_in 'user_email', with: 'andrew.smith@example.com'
          click_button 'Save changes'
        }

        it "redirects the user to their profile page, displaying a success message" do
          expect(page.status_code).to eq(200)
          expect(page.current_path).to eq("/users/#{@user.id}")
          expect(page.body).to have_selector('div.alert.alert-success', text: 'Profile updated')
        end

        it "updates the users databse entry" do
          expect(User.find_by(id: @user.id).name).to eq('Andrew Smith')
          expect(User.find_by(id: @user.id).email).to eq('andrew.smith@example.com')
        end

      end

    end


    context "when a user is not logged in" do

      before(:each) {
        @user = User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
      }

      it "redirects the user to the 'Log' and displays a error message if they try to view an edit page" do
        visit edit_user_path(@user)

        expect(page.current_path).to eq('/login')
        expect(page.body).to have_selector('div.alert.alert-danger', text: "Please log in")
      end

      it "redirects the user to 'Log in' and displays a error message if they try to update a profile" do
        page.driver.submit :patch, user_path(@user), { user: { name: @user.name, email: @user.email } }

        expect(page.current_path).to eq('/login')
        expect(page.body).to have_selector('div.alert.alert-danger', text: "Please log in")
      end

      context "friendly forwarding" do

        it "forwards the user to their settings page if they login" do
          visit edit_user_path(@user)
          redirect_to(login_path)
          fill_in 'session_email', with: 'andrew@example.com'
          fill_in 'session_password', with: 'password'
          click_button 'Log in'

          expect(page.current_path).to eq("/users/#{@user.id}/edit")
          expect(page.body).to have_selector('input[value="Andrew"]')
          expect(page.body).to have_selector('input[value="andrew@example.com"]')
        end

        it "on subsequent logins, redirects the user to their profile page" do
          visit edit_user_path(@user)
          redirect_to(login_path)
          fill_in 'session_email', with: 'andrew@example.com'
          fill_in 'session_password', with: 'password'
          click_button 'Log in'
          click_link 'Log out'
          click_link 'Log in'
          fill_in 'session_email', with: 'andrew@example.com'
          fill_in 'session_password', with: 'password'
          click_button 'Log in'

          expect(page.current_path).to eq("/users/#{@user.id}")
        end

      end

    end


    context "when a logged in user tries to edit another users profile" do

      before(:each) {
        @thomas = User.create(name: 'Thomas', email: 'thomas@example.com', password: 'password', password_confirmation: 'password')
        @andrew = User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
        visit login_path
        fill_in 'session_email', with: 'andrew@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'Log in'
      }

      it "redirects edit to the 'root'" do
        visit edit_user_path(@thomas)

        expect(page.current_path).to eq(root_path)
        expect(page.body).to have_selector('div.alert.alert-danger', text: 'You are not authorised to view that page')
      end


      it "redirects update to the 'root'" do
        page.driver.submit :patch, user_path(@thomas), { user: { name: @thomas.name, email: @thomas.email } }

        expect(page.current_path).to eq(root_path)
        expect(page.body).to have_selector('div.alert.alert-danger', text: 'You are not authorised to view that page')
      end

    end

  end
end
