require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do

  describe "GET '/signup'", type: :feature do
    before(:each){
      visit signup_path
    }

    it "has a title element with the text 'Signup | Twitter Clone App'" do
      expect(page).to have_title(full_title('Signup'))
    end

    it "has a signup form that posts user submitted data to '/signup'" do
      expect(page).to have_selector('form[action="/signup"]')
      expect(page).to have_field('user_name')
      expect(page).to have_field('user_email')
      expect(page).to have_field('user_password')
      expect(page).to have_field('user_password_confirmation')
    end

  end


  describe "signup", type: :feature do
    before(:each){
      visit signup_path
    }

    context "with valid information" do
      it "redirects the user to their profiel page upon successful signup" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Create my account'

        expect(page.status_code).to eq(200)
        expect(page.body).to include('test')
      end
    end

    context "with invalid information" do

      it "displays the error message 'Name can't be blank' if the name field is left blank" do
        fill_in 'user_name', with: '  '
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Create my account'

        expect(page.body).to include("Name can&#39;t be blank")
      end

      it "displays the error message 'Email can't be blank' if the email field is left blank" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: '   '
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Create my account'

        expect(page.body).to include("Email can&#39;t be blank")
      end

      it "displays the error message 'Email is invalid' if an invalid email is supplied" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Create my account'

        expect(page.body).to include("Email is invalid")
      end

      it "displays the error message 'Password cam't be blank' if the password field is left blank" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example'
        fill_in 'user_password', with: '  '
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Create my account'

        expect(page.body).to include("Password can&#39;t be blank")
      end

      it "displays the error message 'Password confirmation doesn't match Password' if the confirmation field is left blank" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: '  '
        click_button 'Create my account'

        expect(page.body).to include("Password confirmation doesn&#39;t match Password")
      end

      it "displays the error message 'Password confirmation doesn't match Password' if password and confirmation fields do not match" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: '123456789'
        click_button 'Create my account'

        expect(page.body).to include("Password confirmation doesn&#39;t match Password")
      end

      it "displays the error message 'Password is too short' if the password is less than 6 characters" do
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'pass'
        fill_in 'user_password_confirmation', with: 'pass'
        click_button 'Create my account'

        expect(page.body).to include("Password is too short")
      end

      it "displays the error message 'email has already been taken' if the user has been registered with the same email" do
        User.create(name: 'test', email: 'test@example.com', password: 'password', password_confirmation: 'password')
        fill_in 'user_name', with: 'test'
        fill_in 'user_email', with: 'test@example.com'
        fill_in 'user_password', with: 'pass'
        fill_in 'user_password_confirmation', with: 'pass'
        click_button 'Create my account'

        expect(page.body).to include("Email has already been taken")
      end

    end

  end

end
