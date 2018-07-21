require 'rails_helper'

RSpec.describe User, type: :model do
  
  # shoulda matchers removes the need to use the valid/invalid code blocks
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe 'is valid' do
    it 'with a first name, last name, email, and password' do
      # user = User.new(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end

  describe 'is invalid' do
    it 'without a fist name' do
      user = User.new(first_name: nil)
      expect(user).to_not be_valid

      user = User.new(first_name: nil)
      user.valid?
      expect(user.errors[:first_name]).to include("can't be blank")

      user = User.create(first_name: nil)
      expect(user.errors[:first_name]).to include("can't be blank")

      user = FactoryBot.build(:user, first_name: nil)
      expect(user).to_not be_valid

      user = FactoryBot.build(:user, first_name: nil)
      user.valid?
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it 'without a last name' do
      user = FactoryBot.build(:user, last_name: nil)
      user.valid?
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it 'without an email address' do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'with a duplicate email adddress' do
      # User.create(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
      # user = User.create(first_name: 'Dick', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
      FactoryBot.create(:user, email: 'test@example.com')
      user = FactoryBot.build(:user, email: 'test@example.com')
      user.valid?
      expect(user.errors[:email]).to include('has already been taken')
    end
  end

  it "return's the user's full name as a string" do
    # user = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    user = FactoryBot.build(:user, first_name: 'Simon', last_name: 'Jones')
    expect(user.name).to eq 'Simon Jones'
  end

  describe 'User has many' do
    before do
      @user = FactoryBot.create(:user)
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