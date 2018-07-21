require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'welcome email' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'sends a welcome email to the users email address' do
      expect(mail.to).to eq [user.email]
    end

    it 'sends from support email address' do
      expect(mail.from).to eq ['support@example.com']
    end

    it 'sends with the correct subject' do
      expect(mail.subject).to eq 'Welcome to Projects!'
    end

    # ensure that the message includes friendly greeting
    it 'greets the user by first name' do
      expect(mail.body).to match(/Hello #{user.first_name},/)
    end

    # ensure that the user's email is found somewhere within the message body
    it 'reminds the user of the registered email address' do
      expect(mail.body).to match(/#{user.email}/)
    end
  end
end
