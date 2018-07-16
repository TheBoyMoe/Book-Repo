require 'rails_helper'

RSpec.describe User, type: :model do

	it 'is valid with a first name, last name, email and password' do
		expect(FactoryBot.build(:user)).to be_valid
	end

	context 'is invalid without' do
		before {
			@user = FactoryBot.build(:user, first_name: nil, last_name: nil, email: nil)
			@user.valid?
		}

		it 'a first name' do
			expect(@user.errors[:first_name]).to include("can't be blank")
		end

		it 'a last name' do
			expect(@user.errors[:last_name]).to include("can't be blank")
		end

		it 'an email address' do
			expect(@user.errors[:email]).to include("can't be blank")
		end
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