require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  # before do
    # sign_in_as(@user)
  # end

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: 'RSpec tutorial', owner: user) }
  let!(:task) { project.tasks.create!(name: 'Finish RSpec tutorial') }

  scenario 'user toggles a task', js: true do
    login_as user, scope: :user # Devise helper method, creates user session
    # visit root_path
    # click_link 'RSpec tutorial'
    go_to_project('RSpec tutorial')
    
    # check 'Finish RSpec tutorial'
    complete_task('Finish RSpec tutorial')
    
    # expect(page).to have_css "label#task_#{task.id}.completed"
    # expect(task.reload).to be_completed
    expect_complete_task('Finish RSpec tutorial')
    
    # uncheck 'Finish RSpec tutorial'
    undo_complete_task('Finish RSpec tutorial')
    
    # expect(page).to_not have_css "label#task#{task.id}.completed"
    # expect(task.reload).to_not be_completed
    expect_incomplete_task('Finish RSpec tutorial')
  end

  scenario 'user creates a new task' do
    login_as user, scope: :user
    visit root_path
    expect {
      click_link 'RSpec tutorial'
      click_link 'Add Task'
      fill_in 'task_name', with: 'New Project Task'
      click_button 'Create Task'
      expect(page).to have_content('New Project Task')
    }.to change(project.tasks, :count).by(1)
  end

  scenario 'user edits a task' do
    login_as user, scope: :user
    visit root_path
    click_link 'RSpec tutorial'
    # click_link 'Add Task'
    # fill_in 'task_name', with: 'New Project Task'
    # click_button 'Create Task'
    within '.task' do
      click_link 'Edit'
    end
    fill_in 'task_name', with: 'New Task Name'
    click_button 'Update Task'
    expect(page).to have_content('New Task Name')
  end

  scenario 'user deletes a task', js: true do
    login_as user, scope: :user
    visit root_path
    click_link 'RSpec tutorial'
    # click_link 'Add Task'
    # fill_in 'task_name', with: 'New Project Task'
    # click_button 'Create Task'
    # expect(page).to have_content('New Project Task')
    expect {
      within '.task' do
        click_link 'Delete'
      end
      page.accept_alert
      expect(page).to_not have_content('Finish RSpec tutorial')
    }.to change(project.tasks, :count).by(-1)
  end

  # helper methods
  def go_to_project(name)
    visit root_path
    click_link(name)
  end

  def complete_task(name)
    check(name)
  end

  def undo_complete_task(name)
    uncheck(name)
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css 'label.completed', text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css 'label.completed', text: name
      expect(task.reload).to_not be_completed
    end
  end
end