require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @project = FactoryBot.create(:project, name: 'RSpec tutorial', owner: @user)
    
    visit root_path
    click_link 'Sign in'
    fill_in 'Email',	with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
  end
  
  scenario 'user toggles a task', js: true do
    task = @project.tasks.create!(name: 'Finish RSpec tutorial')

    click_link 'RSpec tutorial'
    check 'Finish RSpec tutorial'

    expect(page).to have_css "label#task_#{task.id}.completed"
    expect(task.reload).to be_completed

    uncheck 'Finish RSpec tutorial'

    expect(page).to_not have_css "label#task#{task.id}.completed"
    expect(task.reload).to_not be_completed
  end

  scenario 'user creates a new task' do
    expect {
      click_link 'RSpec tutorial'
      click_link 'Add Task'
      fill_in 'task_name', with: 'New Project Task'
      click_button 'Create Task'
      expect(page).to have_content('New Project Task')
    }.to change(@project.tasks, :count).by(1)
  end

  scenario 'user edits a task' do
    click_link 'RSpec tutorial'
    click_link 'Add Task'
    fill_in 'task_name', with: 'New Project Task'
    click_button 'Create Task'
    within '.task' do
      click_link 'Edit'
    end
    fill_in 'task_name', with: 'New Task Name'
    click_button 'Update Task'
    expect(page).to have_content('New Task Name')
  end

  scenario 'user deletes a task', js: true do
    click_link 'RSpec tutorial'
    click_link 'Add Task'
    fill_in 'task_name', with: 'New Project Task'
    click_button 'Create Task'
    expect(page).to have_content('New Project Task')
    expect {
      within '.task' do
        click_link 'Delete'
      end
      page.accept_alert
      expect(page).to_not have_content('New Project Task')
    }.to change(@project.tasks, :count).by(-1)
  end
end