require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    user = User.create(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    @project = Project.create(name: 'Test Project', owner: user)
  end
  
  describe 'is valid' do
    it 'with a name and project' do
      task = Task.create(name: 'New Task', project: @project)
      expect(task).to be_valid
    end
  end

  describe 'is invalid without a' do
    it 'name' do
      task = Task.create(name: nil, project: @project)
      expect(task).to_not be_valid
    end

    it 'project' do
      task = Task.create(name: 'New Task', project: @project)
      expect(task).to_not be_valid
    end
  end
end
