 require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  before do
    @user = FactoryBot.create(:user)
    # sign_in_as(@user)
    login_as @user, scope: :user # Devise helper method
    visit root_path
  end
  
  scenario 'user creates a new project' do
    expect {
      click_link 'New Project'
      fill_in 'Name',	with: 'Test Project'
      fill_in 'Description',	with: 'Trying out Capybara'
      click_button 'Create Project'
      
      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "#{@user.name}"
    }.to change(@user.projects, :count).by(1)
  end
  
  # scenario 'guest adds a project' do
  #   visit projects_path
  #   save_and_open_page # DEBUG
  #   click_link 'New Project'
  # end
  
  scenario 'user updates a project' do
    project = FactoryBot.create(:project,
      owner: @user,
      name: 'Old Project Name',
      description: 'Old Project Description'
    )
    expect {
      click_link project.name
      click_link 'Edit'
      fill_in 'Name',	with: 'New Project Title'
      fill_in 'Description',	with: 'New Project Description'
      click_button 'Update Project'
  
      expect(page).to have_content 'New Project Title'
      expect(page).to have_content 'New Project Description'
      expect(page).to have_content "#{@user.name}"
    }
  end
end
