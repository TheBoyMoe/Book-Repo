require 'rails_helper'

RSpec.describe Project, type: :model do

	before {
		@project = FactoryBot.create(:project)
	}

	it 'is valid with a project name and a owner' do
		expect(@project).to be_valid
	end

	context 'is invalid without a' do
		before {
			@project = FactoryBot.build(:project, name: nil, owner: nil)
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
		# create a project with the same name and owner
		duplicate = FactoryBot.build(:project, name: @project.name, owner: @project.owner)
		duplicate.valid?

		expect(duplicate.errors[:name]).to include('has already been taken')
	end

	it 'allows two users to share a project name' do
		other_user = FactoryBot.create(:user)
		other_project = FactoryBot.create(:project, name: @project.name, owner: other_user)

		expect(other_project).to be_valid
	end
end
