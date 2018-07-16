require 'rails_helper'

RSpec.describe Project, type: :model do
  it "does not allow duplicate project names per user" do
    user = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    user.projects.create(name: 'Test Project')
    project = user.projects.build(name: 'Test Project')
    project.valid?
    expect(project.errors[:name]).to include("has already been taken")
  end

  it "allows two users to share a project name" do
    tom = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    tom.projects.create(name: 'Test Project')
    dick = User.create( first_name: 'Dick', last_name: 'Jones', email: 'dick@ex.com', password: 'password')
    project = dick.projects.build(name: 'Test Project')
    # expect(project.valid?).to be true
    expect(project).to be_valid
  end

end
