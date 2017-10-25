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

    context "form submission", type: :feature do

      it "increments the User count by 1 on successful user submission" do
        post users_path, params: {
          user: {
            name: 'test',
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }

        expect(User.count).to eq(1)
      end

      it "does not change the User count if submission fails" do
        post users_path, params: {
          user: {
            name: '  ',
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }

        expect(User.count).to eq(0)
      end

    end


  end
end
