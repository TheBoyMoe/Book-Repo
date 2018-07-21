require 'rails_helper'

RSpec.feature "Sign Up", type: :feature do
  include ActiveJob::TestHelper

  # test that the mail is dispatched and it's content
  scenario 'user successfully signs up' do
    visit root_path
    click_link 'Sign up'

    # since mail is delivered as a background service,
    # wrap the test in a 'perform_enqueued_jobs' block
    # provided by the 'ActiveJob::TestHelper' module
    perform_enqueued_jobs do
      expect {
        fill_in 'First name', with: 'First'
        fill_in 'Last name', with: 'Last'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'test123'
        fill_in 'Password confirmation', with: 'test123'
        click_button 'Sign up'
      }.to change(User, :count).by(1)

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(current_path).to eq root_path
      expect(page).to have_content 'First Last'
    end

    # access 'ActionMailer::Base.deliverables' and grab the last value
    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["support@example.com"]
      expect(mail.subject).to eq "Welcome to Projects!"
      expect(mail.body).to match "Hello First,"
      expect(mail.body).to match "test@example.com"
    end
  end
end
