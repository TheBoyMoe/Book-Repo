require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  fixtures :all

  before(:each) {
    @admin = users(:michael)
    @user = users(:archer)
    @count = User.count
  }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "#index", type: :feature do
    context "user not logged in" do
      it "redirect the user to the 'Login' page" do
        visit users_path

        expect(page.current_path).to eq('/login')
        expect(page.body).to have_selector('div.alert.alert-danger', text: "Please log in")
      end
    end

    context "user logged in" do
      before(:each){
        visit login_path
        fill_in 'session_email', with: "#{@user.email}"
        fill_in 'session_password', with: 'password'
        click_button 'Log in'
        visit users_path
      }
      render_views

      it "display a list of all the users" do
        expect(page.current_path).to eq('/users')
        expect(page.body).to have_selector('a', text: "#{@admin.name}")
        expect(page.body).to have_selector('a', text: "#{@user.name}")
      end

    end

  end


  describe "#destroy", type: :feature do

    context "not logged in" do
      it "redirects users to the login page" do
        page.driver.submit :delete, user_path(@user), { user: { name: @user.name, email: @user.email } }

        expect(User.count).to eq(@count)
        expect(page.current_path).to eq('/login')
        expect(page.body).to have_selector('div.alert.alert-danger', text: "Please log in")
      end

    end

    context "logged in" do
      it "redirects users who are not admins to the 'root' page" do
        visit login_path
        fill_in 'session_email', with: "#{@user.email}"
        fill_in 'session_password', with: "password"
        click_button 'Log in'
        page.driver.submit :delete, user_path(@admin), { user: { name: @admin.name, email: @admin.email } }

        expect(User.count).to eq(@count)
        expect(page.current_path).to eq(root_path)
      end

      context 'as admin' do
        before(:each){
          visit login_path
          fill_in 'session_email', with: "#{@admin.email}"
          fill_in 'session_password', with: "password"
          click_button 'Log in'
        }
        render_views

        it "deletes the the record" do
          page.driver.submit :delete, user_path(@user), { user: { name: @user.name, email: @user.email } }

          expect(User.count).to eq(@count - 1)
        end

        it "deletes the record by clicking on a delete link" do
          click_link 'Users'
          find("a[href='/users/#{@user.id}']", text: 'delete').click

          expect(User.count).to eq(@count - 1)
        end
      end


    end
  end
end
