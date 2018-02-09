require 'rails_helper'

RSpec.describe Project, type: :model do
	before {
		@user = User.create(
				first_name: 'Joe',
				last_name: 'Smith',
				email: 'joe@ex.com',
				password: 'password'
		)
		@user.projects.create(name: 'Web Development with Rails')
	}

	it 'does not allow duplicate project names per user' do
		duplicate = @user.projects.build(name: 'Web Development with Rails')
		duplicate.valid?

		expect(duplicate.errors[:name]).to include('has already been taken')
	end

	it 'allows two users to share a project name' do
		other_user = User.create(
				first_name: 'Tom',
				last_name: 'Smith',
				email: 'tom@ex.com',
				password: 'password'
		)
		other_project = other_user.projects.build(name: 'Web Development with Rails')

		expect(other_project).to be_valid
	end
end
