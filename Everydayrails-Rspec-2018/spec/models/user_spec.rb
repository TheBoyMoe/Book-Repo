require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a first name, last name, email, and password" do
    user = User.new( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    expect(user).to be_valid
  end

  it "is invalid without a fist name" do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid without a last name" do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "is invalid without an email address" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  
  it "is invalid with a duplicate email adddress" do
    User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    user = User.new( first_name: 'Dick', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "return's the user's full name as a string" do
    user = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    expect(user.name).to eq "Tom Jones"
  end
end
