require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { FactoryBot.create(:project) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:project) } 

  describe 'is valid' do
    it 'with a name and project' do
      task = Task.create(name: 'New Task', project: project)
      expect(task).to be_valid

      task = FactoryBot.build(:task) # alternate
      expect(task).to be_valid
    end
  end

  describe 'is invalid without a' do
    it 'name' do
      task = Task.create(name: nil, project: project)
      expect(task).to_not be_valid

      task = FactoryBot.build(:task, name: nil) # alternate
      task.valid?
      expect(task.errors[:name]).to include("can't be blank")
    end

    it 'project' do
      task = Task.create(name: 'New Task', project: nil)
      expect(task).to_not be_valid

      task = FactoryBot.build(:task, project: nil) # alternate
      task.valid?
      expect(task.errors[:project]).to include('must exist')
    end
  end
end
