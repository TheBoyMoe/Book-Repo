require 'rails_helper'

RSpec.describe Note, type: :model do
  it "returns notes that match the search term" do
    user = User.create( first_name: 'Tom', last_name: 'Jones', email: 'tom@ex.com', password: 'password')
    project = user.projects.create(name: 'Test Project')
    note1 = project.notes.create(message: 'First note', user: user)
    note2 = project.notes.create(message: 'Second note', user: user)
    note3 = project.notes.create(message: 'Third note, with first in the message', user: user)

    expect(Note.search('first')).to include(note1, note3)
    expect(Note.search('first')).to_not include(note2)
    expect(Note.search('fourth')).to be_empty
  end
end
