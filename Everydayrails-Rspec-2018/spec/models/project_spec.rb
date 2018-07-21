require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:notes) }
  it { is_expected.to have_many(:tasks) }
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  it 'is valid with a name and owner' do
    project = Project.create(name: 'Test Project', owner: @user)
    expect(project).to be_valid

    project = FactoryBot.build(:project, name: 'New Project', owner: @user)
    expect(project).to be_valid
  end

  describe 'it is invalid without a' do
    it 'name' do
      project = @user.projects.new(name: nil)
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")

      project = FactoryBot.build(:project, name: nil)
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end

    it 'owner' do
      project = Project.create(name: 'Test Project', owner: nil)
      expect(project.errors[:owner]).to include('must exist')

      project = FactoryBot.build(:project, owner: nil)
      project.valid?
      expect(project.errors[:owner]).to include('must exist')
    end
  end

  it 'does not allow duplicate project names with the same user' do
    @user.projects.create(name: 'Test Project')
    project = @user.projects.build(name: 'Test Project')
    project.valid?
    expect(project.errors[:name]).to include('has already been taken')

    FactoryBot.create(:project, name: 'New Project', owner: @user)
    project = FactoryBot.build(:project, name: 'New Project', owner: @user)
    project.valid?
    expect(project.errors[:name]).to include('has already been taken')
  end

  it 'allows two users to share a project name' do
    @user.projects.create(name: 'Test Project')
    dick = User.create( first_name: 'Dick', last_name: 'Jones', email: 'dick@ex.com', password: 'password')
    project = dick.projects.build(name: 'Test Project')
    # expect(project.valid?).to be true
    expect(project).to be_valid

    FactoryBot.create(:project, name: 'New Project')
    project = FactoryBot.build(:project, name: 'New Project')
    project.valid?
    expect(project).to be_valid
  end

  it 'belongs to a User' do
    project = @user.projects.build(name: 'Test Project')
    expect(project.user_id).to eq @user.id
  end

  describe 'Project has many' do
    before do
      @project = @user.projects.build(name: 'Test Project')
    end
    
    it 'notes' do
      note = Note.create(message: 'New note', project: @project, user: @user)
      expect(@project.notes).to include(note)

      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end
    
    it 'tasks' do
      task = Task.create(name: 'New Task', project: @project)
      expect(@project.tasks).to include(task)

      project = FactoryBot.create(:project, :with_tasks)
      expect(project.tasks.length).to eq 5
    end
  end

  describe 'late status' do
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

  describe 'late status using traits' do
    it 'is late when the due date is past today' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when the due date is today' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end
    
    it 'is on time when the due date is in the future' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
  
end
