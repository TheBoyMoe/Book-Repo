require 'rails_helper'

RSpec.describe Note, type: :model do

	it 'returns notes that match the search term' do
    user = User.create(
        first_name: 'Joe',
        last_name: 'Smith',
        email: 'joe@ex.com',
        password: 'password'
    )
		project = user.projects.create(name: 'project 1')
		note_1 = project.notes.create(message: 'note 1, with some dummy text', user: user)
		note_2 = project.notes.create(message: 'note 2, with even more text', user: user)
		note_3 = project.notes.create(message: 'note 3, just add the dummy', user: user)

		expect(Note.search('dummy')).to include(note_1, note_3)
		expect(Note.search('text')).to_not include(note_3)
	end

end
