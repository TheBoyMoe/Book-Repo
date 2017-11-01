require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do

  fixtures :all

  describe "GET /password_resets" do
    it "works! (now write some real specs)" do
      get new_password_reset_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /password_reset/new", type: :feature do
    # password_reset/new => invalid submission
      # generates error message

    before(:each){
      visit new_password_reset_path
    }
    let(:user){users(:archer)}

    context "provide invalid information" do
      it "displays an error message if the email field is blank, user remains on the current page" do
        fill_in 'password_reset_email', with: '  '
        click_button 'Submit'

        expect(page.current_path).to eq('/password_resets')
        expect(page.body).to have_selector('div.alert.alert-danger', text: 'Email address not found')
      end

      it "displays an error message if the email address is not found, user remains on the current page" do
        fill_in 'password_reset_email', with: 'qwerty@example.com'
        click_button 'Submit'

        expect(page.current_path).to eq('/password_resets')
        expect(page.body).to have_selector('div.alert.alert-danger', text: 'Email address not found')
      end

    end

    # password_reset/new => valid submission
    # generates email
    # generates token
    # generates info message
    context "provide valid information" do
      before(:each){
        fill_in 'password_reset_email', with: "#{user.email}"
        click_button 'Submit'
      }

      it "displays a message informing the user to check their email, redirects user to the root page" do
        expect(page.current_path).to eq('/')
        expect(page.body).to have_selector('div.alert.alert-info', text: 'Email sent with password reset instructions')
      end

      it "sets reset_digest & reset_sent_at" do
        user.reload
        expect(user.reset_digest).not_to be nil
        expect(user.reset_sent_at).not_to be nil
      end

      # REVIEW: authentication fails
      xit "generates a reset token when user clicks on the link in the email" do
        user.reload
        user.reset_token = User.new_token
        page.driver.submit :get,  edit_password_reset_path(user.reset_token, email: user.email), {user: { name: user.name, email: user.email } }
        # binding.pry
      end

      it "sends out an email when user clicks on the link in the email"

      xit "displays an error message if their account is inactive, when user clicks on the link in the email" do
        # check account activated
        # need to click on email link

      end


    end

  end

  # REVIEW: to complete section 12.3.3
  xdescribe "GET /password_reset/edit" do
    # password_reset/edit => invalid submission
    # generates error message

    # password_reset/edit => valid submission
    # logs user in

    context "provide invalid information" do

    end

    context "provide valid information" do

    end

  end

  xdescribe "expired password" do
    # listing 12.21
  end


end
