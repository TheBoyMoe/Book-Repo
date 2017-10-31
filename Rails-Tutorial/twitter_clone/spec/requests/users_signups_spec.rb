require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /users_signups" do

    before(:each) {
      ActionMailer::Base.deliveries.clear
      User.destroy_all
      get signup_path
    }

    it "works! (now write some real specs)" do
      expect(response).to have_http_status(200)
    end

    describe "form submission", type: :feature do

      before(:each) {
        visit signup_path
        fill_in 'user_name', with: 'user'
        fill_in 'user_email', with: 'user@email.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Create my account'
      }
      context "with valid user credntials" do

        it "creates an inactive user" do
          expect(User.count).to eq(1)
          expect(User.last.activated?).to eq(false)
        end

        it "directs the user to check their email to activate the account" do
          expect(page.body).to have_selector('div.alert.alert-success', text: 'Please check your email to activate your account.')
        end

        # REVIEW: listing 11.33 - simulate clicking link in email
        xit "logs the user in following account activation" do
          user = User.last
          user.activation_token = User.new_token
          get edit_account_activation_path(user.activation_token, email: user.email)

          binding.pry
          expect(user.activated?).to eq(true)
          expect(is_logged_in?).to be true
        end

      end

      context "with invalid user credentials" do
        before(:each) {
          User.destroy_all
          post signup_path, params: {
            user: {
              name: '  ',
              email: 'user@example.com',
              password: 'password',
              password_confirmation: 'password'
            }
          }
        }

        it "fails to create user if submission fails" do
          expect(User.count).to eq(0)
        end

      end

    end


  end
end
