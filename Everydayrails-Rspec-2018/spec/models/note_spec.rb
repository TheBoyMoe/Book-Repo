require 'rails_helper'

RSpec.describe Note, type: :model do  
  before do
    @user = User.create(first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    @project = @user.projects.create(name: 'Test Project')
  end
  
  describe 'is valid with' do
    it 'a message, project and user' do
      note = Note.new(message: 'New note', project: @project, user: @user)
      expect(note).to be_valid

      note = FactoryBot.build(:note)
      expect(note).to be_valid
    end
  end
  
  describe 'is invalid without a' do
    it 'message' do
      note = Note.new(message: nil, project: @project, user: @user)
      note.valid?
      expect(note.errors[:message]).to include("can't be blank")

      note = FactoryBot.build(:note, message: nil)
      note.valid?
      expect(note.errors[:message]).to include("can't be blank")
    end
    
    it 'user' do
      note = Note.create(message: 'New note', project: @project, user: nil)
      expect(note.errors[:user]).to include('must exist')

      note = FactoryBot.build(:note, user: nil)
      note.valid?
      expect(note.errors[:user]).to include('must exist')
    end
  
    it 'project' do
      note = Note.create(message: 'New note', project: nil, user: @user)
      expect(note.errors[:project]).to include('must exist')

      note = FactoryBot.build(:note, project: nil, user: @user)
      note.valid?
      expect(note.errors[:project]).to include('must exist')
    end
  end
  
  describe 'search message for a term' do
    before do
      @note1 = @project.notes.create(message: 'First note', user: @user)
      @note2 = @project.notes.create(message: 'Second note', user: @user)
      @note3 = @project.notes.create(message: 'Third note, with first in the message', user: @user)
    end
    
    context 'when a match is found' do
      it 'returns notes that match the search term' do
        expect(Note.search('first')).to include(@note1, @note3)
      end
    end
    
    context 'when no match is found' do
      it 'returns an empty collection' do
        expect(Note.search('fourth')).to be_empty
      end
    end
  end
end