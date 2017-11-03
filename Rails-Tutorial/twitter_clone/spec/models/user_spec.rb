require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) {User.new(name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password')}

  fixtures :all

  it "is a valid user" do
    expect(user).to be_valid
    expect(user).to respond_to(:name)
    expect(user).to respond_to(:email)
    expect(user).to respond_to(:password_digest)
    expect(user).to respond_to(:password)
    expect(user).to respond_to(:password_confirmation)
    expect(user).to respond_to(:remember_token)
    expect(user).to respond_to(:authenticate)
    expect(user).to respond_to(:admin)
  end

  it "should have a value for the name attribute" do
    user.update_attribute(:name, '    ')
    expect(user).not_to be_valid
  end

  it "should have a name less than 61 characters in length" do
    user.update_attribute(:name, 'a' * 61)
    expect(user).not_to be_valid
  end


  it "should have a value for the email attribute" do
    user.update_attribute(:email, '   ')
    expect(user).not_to be_valid
  end

  it "should have an email address less than 255 characters in length" do
    user.update_attribute(:email, 'a' * 244 + '@example.com')
    expect(user).not_to be_valid
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    addresses.each do |invalid_address|
      user.update_attribute(:email, invalid_address)
      expect(user).not_to be_valid
    end
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |valid_address|
      user.update_attribute(:email, valid_address)
      expect(user).to be_valid
    end
  end

  it "should ensure that email addresses are unique" do
    user2 = User.create(name: 'user2', email: 'user@example.com')
    expect(user2).not_to be_valid
  end

  it "should ensure email address are saved as lowercase" do
    user.update_attribute(:email, 'FoO@BAR.com')
    expect(user.reload.email).to eq('foo@bar.com')
  end

  it "should ensure passwords, and password confirmations are not blank" do
    user.update_attributes(password: '  ', password_confirmation: '  ')
    expect(user).not_to be_valid
  end

  it "should ensure that password and password confirmation match" do
    user.update_attributes(password: 'password1', password_confirmation: 'password2')
    expect(user).not_to be_valid
  end

  it "should ensure passwords have a minimum length of 6 characters" do
    user.update_attribute(:password, 'a' * 5)
    expect(user).not_to be_valid
  end

  describe "authenticated?" do

    it "returns false for a user with a nil digest" do
      expect(user.authenticated?(:remember, '')).to eq(false)
    end
  end

  context "admin attribute", type: :feature do

    let(:user) {User.create(name: 'test', email: 'test@ex.com', password: 'password')}

    before(:each) {
      visit login_path
      fill_in 'session_email', with: "test@ex.com"
      fill_in 'session_password', with: "password"
      click_button 'Log in'
    }

    it "users by default are not administrators" do
      expect(user.admin?).to eq(false)
    end

    it "prevents the admin attribute being edited via the web" do
      page.driver.submit :patch, user_path(user), { user: {password: 'password', password_confirmation: 'password', admin: true } }

      expect(user.admin?).to eq(false)
    end
  end

  context "follow and unfollow" do
    let(:michael){users(:michael)}
    let(:archer){users(:archer)}
    let!(:count){michael.following.count}

    it "allows a user to follow another user" do
      michael.follow(archer)

      expect(michael.following.count).to eq(count + 1)
      expect(michael.following?(archer)).to eq(true)
      expect(archer.following?(michael)).to eq(false)
    end

    it "allows a user to unfollow another user" do
      michael.follow(archer)
      michael.unfollow(archer)

      expect(michael.following.count).to eq(count)
      expect(michael.following?(archer)).to eq(false)
    end
  end

end
