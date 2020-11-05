require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "notification_email" do
    let(:email) { 'admin@example.com' }
    let(:message) { "Its a message." }
    

    it "send the email, then test that it got queued" do
      UserMailer.with(email: email, message: message).notification_email.deliver
      assert !ActionMailer::Base.deliveries.empty?
    end

    it "Test the body of the sent email contains what we expect it to" do
      mail = UserMailer.with(email: email, message: message).notification_email
      expect(mail.body).to include(message)
    end
  end
end
