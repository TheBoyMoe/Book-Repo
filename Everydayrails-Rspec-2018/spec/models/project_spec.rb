require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @tom = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
  end
  
  it 'is valid with a name and owner' do
    project = Project.create(name: 'Test Project', owner: @tom)
    expect(project).to be_valid
  end

  describe 'it is invalid without a' do
    it 'name' do
      project = @tom.projects.new(name: nil)
      project.valid?
      expect(project.errors[:name]).to include("can't be blank")
    end

    it 'owner' do
      project = Project.create(name: 'Test Project', owner: nil)
      expect(project.errors[:owner]).to include('must exist')
    end
  end

  it 'does not allow duplicate project names per user' do
    @tom.projects.create(name: 'Test Project')
    project = @tom.projects.build(name: 'Test Project')
    project.valid?
    expect(project.errors[:name]).to include('has already been taken')
  end

  it 'allows two users to share a project name' do
    @tom.projects.create(name: 'Test Project')
    dick = User.create( first_name: 'Dick', last_name: 'Jones', email: 'dick@ex.com', password: 'password')
    project = dick.projects.build(name: 'Test Project')
    # expect(project.valid?).to be true
    expect(project).to be_valid
  end

  it 'belongs to a User' do
    project = @tom.projects.build(name: 'Test Project')
    expect(project.user_id).to eq @tom.id
  end

  describe 'Project has many' do
    before do
      @project = @tom.projects.build(name: 'Test Project')
    end
    
    it 'notes' do
      note = Note.create(message: 'New note', project: @project, user: @tom)
      expect(@project.notes).to include(note)
    end
    
    it 'tasks' do
      task = Task.create(name: 'New Task', project: @project)
      expect(@project.tasks).to include(task)
    end
  end
end
