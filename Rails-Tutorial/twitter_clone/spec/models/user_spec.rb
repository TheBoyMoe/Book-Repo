require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) {User.create(name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password')}

  it "is a valid user" do
    expect(user).to be_valid
    expect(user).to respond_to(:name)
    expect(user).to respond_to(:email)
    expect(user).to respond_to(:password_digest)
    expect(user).to respond_to(:password)
    expect(user).to respond_to(:password_confirmation)
    expect(user).to respond_to(:remember_token)
    expect(user).to respond_to(:authenticate)
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

end
