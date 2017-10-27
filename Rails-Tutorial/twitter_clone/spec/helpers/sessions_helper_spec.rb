require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do

  # REVIEW: section 9.3.2 - testing remeber branch
  context "#current_user", type: :feature do

    before(:each){
      @user = User.create(name: 'Andrew', email: 'andrew@example.com', password: 'password', password_confirmation: 'password')
      visit login_path
      fill_in 'session_email', with: 'andrew@example.com'
      fill_in 'session_password', with: 'password'
      click_button 'Log in'
    }

    it "it returns the 'current_user' when the session is nil"


    it "it returns nil when the 'remember_digest' is nil"

  end

end
