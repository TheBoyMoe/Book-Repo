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

	context 'names may' do
		it 'not be repeated by the same user' do
			# create a project with the same name and owner
			duplicate = FactoryBot.build(:project, name: @project.name, owner: @project.owner)
			duplicate.valid?

			expect(duplicate.errors[:name]).to include('has already been taken')
		end

		it 'be repeated by different users' do
			other_user = FactoryBot.create(:user)
			other_project = FactoryBot.create(:project, name: @project.name, owner: other_user)

			expect(other_project).to be_valid
		end
	end

	context 'late status' do
		it 'is late when the due date is past today' do
			project = FactoryBot.create(:project_due_yesterday)
			expect(project).to be_late
		end

		it 'is on time when the due date is today' do
			project = FactoryBot.create(:project_due_today)
			expect(project).to_not be_late
		end

		it 'is on time when the due date is in the future' do
			project = FactoryBot.create(:project_due_tomorrow)
			expect(project).to_not be_late
		end
	end

	it 'can have many notes' do
		# create the factory instance, calling the 'with_notes' trait
		project = FactoryBot.create(:project, :with_notes)
		expect(project.notes.count).to eq 5
	end

end
