require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'is valid' do
    it 'with a first name, last name, email, and password' do
      user = User.new(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
      expect(user).to be_valid
    end
  end

  describe 'is invalid' do
    it 'without a fist name' do
      user = User.create(first_name: nil)
      expect(user.errors[:first_name]).to include("can't be blank")
    end
  
    it 'without a last name' do
      user = User.create(last_name: nil)
      expect(user.errors[:last_name]).to include("can't be blank")
    end
  
    it 'without an email address' do
      user = User.create(email: nil)
      expect(user.errors[:email]).to include("can't be blank")
    end
    
    it 'with a duplicate email adddress' do
      User.create(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
      user = User.create( first_name: 'Dick', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  it "return's the user's full name as a string" do
    user = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    expect(user.name).to eq 'Tom Jones'
  end

  describe 'User has many' do
    before do
      @user = User.new(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')      
      @project = Project.create(name: 'Test Project', owner: @user)
      @note = Note.create(message: 'New message', project: @project, user: @user)
    end
    
    it 'notes' do
      expect(@user.notes).to include(@note)
    end

    it 'projects' do
      expect(@user.projects).to include(@project)
    end
  end
  
end
