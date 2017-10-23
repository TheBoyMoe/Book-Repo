require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) {User.create(name: 'user', email: 'user@example.com')}

  it "is a valid user" do
    expect(user).to be_valid
    expect(user).to respond_to(:name)
    expect(user).to respond_to(:email)
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

end
