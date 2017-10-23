require 'rails_helper'

RSpec.describe "users/new.html.erb", type: :view do

  describe "GET '/signup'", type: :feature do
    before(:each){
      visit signup_path
    }

    it "has a title element with the text 'Signup | Twitter Clone App'" do
      expect(page).to have_title(full_title('Signup'))
    end

    it "has a signup form to allow user to enter their details"

    it "has a signup button to allow users to submit those details"

  end

end
