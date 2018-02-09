require 'rails_helper'

RSpec.describe User, type: :model do

	it 'is valid with a first name, last name, email and password' do
		expect(FactoryBot.build(:user)).to be_valid
	end

	# using the factory defined in `spec/factories/users.rb` replace each attribute in turn
	it 'is invalid without a first name' do
		user = FactoryBot.build(:user, first_name: nil)
		user.valid?
		expect(user.errors[:first_name]).to include("can't be blank")
	end

	it 'is invalid without a last name' do
		user = FactoryBot.build(:user, last_name: nil)
		user.valid?
		expect(user.errors[:last_name]).to include("can't be blank")
	end

	it 'is invalid without an email address' do
		user = FactoryBot.build(:user, email: nil)
		user.valid?
		expect(user.errors[:email]).to include("can't be blank")
	end

	it 'is invalid with a duplicate email address' do
		FactoryBot.create(:user, email: 'tom@example.com') # persist a user to the test database
		user = FactoryBot.build(:user, email: 'tom@example.com') # persist a user to memory
		user.valid?

		expect(user.errors[:email]).to include('has already been taken')
	end

	it "returns a user's full name as a string" do
		user = FactoryBot.create(:user, first_name: 'Peter', last_name: 'Jones')
		expect(user.name).to eq('Peter Jones')
	end

end