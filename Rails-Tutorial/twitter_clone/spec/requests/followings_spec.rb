require 'rails_helper'

RSpec.describe "Followings", type: :request do

  fixtures :all
  let(:user) {users(:michael)}
  let(:following) {user.following}
  let(:followers) {user.followers}

  before(:each) {
    visit login_path
    fill_in 'session_email', with: "#{user.email}"
    fill_in 'session_password', with: 'password'
    click_button 'Log in'
  }
  # REVIEW: section 14.2.3 - listing 14.29
  describe "following", type: :feature do
    before(:each) {
      visit following_user_path(user)
    }

    it "displays the correct number of users the user is following" do
      following_count = find('#following').text.to_i
      expect(following_count).to eq(following.count)
    end

    it "redirects to the 'follower' page when clicking on the 'followers' link"

    it "redirects to the appropriate profile when clicking on one of the followed avatars"

  end

  describe "followers", type: :feature do

    before(:each){
      visit followers_user_path(user)
    }

    it "displays the corrent number of followers" do
      followers_count = find('#followers').text.to_i
      expect(followers_count).to eq(followers.count)
    end

    it "redirects to the 'following' page when clicking on the 'following' link"

    it "redirects to the appropriate profile when clicking on one of the following avatars"

  end
end
