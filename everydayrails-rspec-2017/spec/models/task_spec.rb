require 'rails_helper'

RSpec.describe Task, type: :model do

  it 'is valid with a name and project' do
    user = User.create(
        first_name: 'Joe',
        last_name: 'Smith',
        email: 'joe@ex.com',
        password: 'password'
    )
    project = user.projects.create(name: 'Web Development with Rails')
		task = project.tasks.create(name: 'Task 1')

		expect(task).to be_valid
	end

	context 'it is invalid without a' do
    before {
      @task = Task.new(name: nil)
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
