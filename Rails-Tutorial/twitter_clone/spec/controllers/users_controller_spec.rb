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
      @thomas = User.create(name: 'Thomas Jones', email: 'thomas@example.com', password: 'password', password_confirmation: 'password')
      @andrew = User.create(name: 'Andrew Jones', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
    end

    context "user not logged in", type: :feature do
      it "should redirect the user to the 'Login' page" do
        visit users_path

        expect(page.current_path).to eq('/login')
        expect(page.body).to have_selector('div.alert.alert-danger', text: "Please log in")
      end
    end

    context "user logged in", type: :feature do
      before(:each){
        visit login_path
        fill_in 'session_email', with: 'andrew@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'Log in'
        visit users_path
      }
      render_views

      it "display a list of all the users" do
        expect(page.current_path).to eq('/users')
        expect(page.body).to have_selector('a', text: 'Thomas Jones')
        expect(page.body).to have_selector('a', text: 'Andrew Jones')
      end
    end
  end

end
