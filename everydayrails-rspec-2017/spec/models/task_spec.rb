require 'rails_helper'

RSpec.describe Task, type: :model do

  it 'is valid with a name and project' do
		task = FactoryBot.create(:task)
		expect(task).to be_valid
	end

	context 'it is invalid without a' do
		before {
			@task = FactoryBot.build(:task, name: nil, project: nil)
			@task.valid?
		}

		it 'name' do
			expect(@task.errors[:name]).to include("can't be blank")
		end

		it 'project' do
			expect(@task.errors[:project]).to include('must exist')
		end

	end
end
