require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "notification_email" do
    let(:email) { 'admin@example.com' }
    let(:message) { "Its a message." }

    it "Test the body of the sent email contains what we expect it to" do
      mail = UserMailer.with(email: email, message: message).notification_email
      expect(mail.body).to include(message)
    end
  end
end
