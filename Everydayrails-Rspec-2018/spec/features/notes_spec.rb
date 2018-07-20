require 'rails_helper'

RSpec.feature "Notes", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, name: 'RSpec tutorial', owner: @user)
    sign_in_as(@user)
    click_link 'RSpec tutorial'
  end
  
  scenario 'user creates a new note' do
    expect {
      click_link 'Add Note'
      fill_in 'note_message',	with: 'New Note Message'
      click_button 'Create Note'
      expect(page).to have_content('New Note Message')
    }.to change(@project.notes, :count).by(1)
  end

  scenario 'user edits a note' do
    click_link 'Add Note'
    fill_in 'note_message',	with: 'New Note Message'
    click_button 'Create Note'
    within '.note' do
      click_link 'Edit'
    end
    fill_in 'note_message', with: 'Updated Note Message'
    click_button 'Update Note'
    expect(page).to have_content('Updated Note Message')
  end

  scenario 'user deletes a note', js: true do
    click_link 'Add Note'
    fill_in 'note_message',	with: 'New Note Message'
    click_button 'Create Note'
    expect(page).to have_content('New Note Message')
    expect {
      within '.note' do
        click_link 'Delete'
      end
      page.accept_alert
      expect(page).to_not have_content('New Note Message')
    }.to change(@project.notes, :count).by(-1)
  end
end
