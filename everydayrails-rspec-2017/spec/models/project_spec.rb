require 'rails_helper'

RSpec.describe Project, type: :model do
	before {
		@user = User.create(
				first_name: 'Joe',
				last_name: 'Smith',
				email: 'joe@ex.com',
				password: 'password'
		)
		@project = @user.projects.create(name: 'Web Development with Rails')
	}

	it 'is valid with a project name and a owner' do
		expect(@project).to be_valid
	end

	context 'is invalid without a' do
		before {
			@project = Project.new(name: nil)
			@project.valid?
		}

		it 'project name' do
			expect(@project.errors[:name]).to include("can't be blank")
		end

		it 'owner' do
			expect(@project.errors[:owner]).to include('must exist')
		end

	end

	it 'does not allow duplicate project names per user' do
		duplicate = @user.projects.build(name: @project.name)
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
		other_project = other_user.projects.build(name: @project.name)

		expect(other_project).to be_valid
	end
end
