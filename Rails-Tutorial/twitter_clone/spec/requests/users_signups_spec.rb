require 'rails_helper'

RSpec.describe "UsersSignups", type: :request do
  describe "GET /users_signups" do

    before(:each) {
      User.destroy_all
      get signup_path
    }

    it "works! (now write some real specs)" do
      expect(response).to have_http_status(200)
    end

    describe "form submission" do

      context "with valid user credntials" do
        before(:each) {
          post signup_path, params: {
            user: {
              name: 'test',
              email: 'user@example.com',
              password: 'password',
              password_confirmation: 'password'
            }
          }
        }

        it "increments the User count by 1 on successful user submission" do
          expect(User.count).to eq(1)
        end

        # REVIEW: user nolonger signed in due to adding email activation feature
        xit "logs the user in" do
          expect(is_logged_in?).to be true
        end

      end


      context "with invalid user credentials" do
        before(:each) {
          post signup_path, params: {
            user: {
              name: '  ',
              email: 'user@example.com',
              password: 'password',
              password_confirmation: 'password'
            }
          }
        }

        it "does not change the User count if submission fails" do
          expect(User.count).to eq(0)
        end

        it "does not log in the user" do
          expect(is_logged_in?).to be false
        end

      end

    end


  end
end
