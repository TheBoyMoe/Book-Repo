require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "#index" do
    before(:each) do
      @thomas = User.create(name: 'Thomas', email: 'thomas@example.com', password: 'password', password_confirmation: 'password')
      @andrew = User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
    end

    context "user not logged in", type: :feature do
      it "should redirect the user to the 'Login' page" do
        visit users_path
        binding.pry
        expect(page.current_path).to eq('/login')
        expect(page.body).to have_selector('div.alert.alert-danger', text: "Please log in")
      end
    end


    context "user logged in"
  end

end
