require 'rails_helper'

RSpec.describe Note, type: :model do

	# DEBUG test that the correct factory instances/associations are created
	it 'generates associated data from a factory' do
		note = FactoryBot.create(:note)
		puts "project: #{note.project.inspect}"
		puts "user: #{note.user.inspect}"
	end

	# before {
  #   @user = User.create(
  #       first_name: 'Joe',
  #       last_name: 'Smith',
  #       email: 'joe@ex.com',
  #       password: 'password'
  #   )
  #   @project = @user.projects.create(name: 'project 1')
  # }

	it 'is valid with a user, project and message' do
		# note = Note.create(message: 'New Note', user: @user, project: @project)
		note = FactoryBot.create(:note)

		expect(note).to be_valid
	end

	context 'is invalid without a' do
		before {
      @note = Note.new(message: nil)
      @note.valid?
    }

		it 'message' do
      expect(@note.errors[:message]).to include("can't be blank")
		end

		it 'project' do
      expect(@note.errors[:project]).to include("must exist")
		end

		it 'user' do
      expect(@note.errors[:user]).to include("must exist")
    end
	end

  # use describe to outline general functionality or feature
  describe 'search note for a term' do
    before {
			# project = FactoryBot.create(:project)
			# @note_1 = project.notes.create(message: 'note 1, with some dummy text', user: @user)
			# @note_2 = project.notes.create(message: 'note 2, with even more text', user: @user)
			# @note_3 = project.notes.create(message: 'note 3, just add the dummy', user: @user)
			@note_1 = FactoryBot.create(:note, message: 'note 1, with some dummy text')
			@note_2 = FactoryBot.create(:note, message: 'note 2, with even more text')
			@note_3 = FactoryBot.create(:note, message: 'note 3, just add the dummy')
    }

    # use context to outline a specific state
    context 'when a match is found' do

      # happy path
      it 'returns notes that match the search term' do
        expect(Note.search('dummy')).to include(@note_1, @note_3)
        expect(Note.search('text')).to_not include(@note_3)
      end
    end

		context 'when no match is found' do
      # sad path
      it 'returns an empty collection when no results are found' do
        expect(Note.search('content')).to be_empty
				expect(Note.search('text')).to_not be_empty # DEBUG tests before block
      end
		end

  end

end
