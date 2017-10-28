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


    context "with valid information"



  end
end
