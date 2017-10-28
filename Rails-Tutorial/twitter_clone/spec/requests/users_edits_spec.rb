require 'rails_helper'

RSpec.describe "UsersEdits", type: :request do

  describe "profile edit", type: :feature do
    let(:user) {User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')}

    before(:each) {
      visit edit_user_path(user)
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
        expect(page.current_path).to eq("/users/#{user.id}")
        expect(page.body).to have_selector('div.alert.alert-success', text: 'Profile updated')
      end

      it "updates the users databse entry" do
        expect(User.find_by(id: user.id).name).to eq('Andrew Smith')
        expect(User.find_by(id: user.id).email).to eq('andrew.smith@example.com')
      end

    end



  end
end
