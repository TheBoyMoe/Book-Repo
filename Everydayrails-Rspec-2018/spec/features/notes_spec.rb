require 'rails_helper'

RSpec.feature "Notes", type: :feature do

  # before do
  #   # sign_in_as(@user)
  #   login_as @user, scope: :user # Devise helper method
  #   visit root_path
  #   click_link 'RSpec tutorial'
  # end

  let(:user) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project, name: 'RSpec tutorial', owner: user) }

  scenario 'user uploads an attachment' do
    login_as user, scope: :user
    visit project_path(project)
    click_link 'Add Note'
    fill_in 'Message', with: 'My book cover'
    attach_file 'Attachment', "#{Rails.root}/spec/files/attachment.jpg"
    click_button 'Create Note'
    expect(page).to have_content 'Note was successfully created'
    expect(page).to have_content 'My book cover'
    expect(page).to have_content 'attachment.jpg (image/jpeg'
  end

  scenario 'user creates a new note' do
    test_setup(user, 'RSpec tutorial')
    expect {
      click_link 'Add Note'
      fill_in 'note_message',	with: 'New Note Message'
      click_button 'Create Note'
      expect(page).to have_content('New Note Message')
    }.to change(project.notes, :count).by(1)
  end

  scenario 'user edits a note' do
    test_setup(user, 'RSpec tutorial')
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
    test_setup(user, 'RSpec tutorial')
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
    }.to change(project.notes, :count).by(-1)
  end

  def test_setup(user, link)
    login_as user, scope: :user # Devise helper method
    visit root_path
    click_link(link)
  end
end