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

  describe "user_not_covid_19_vaccinated" do
    let(:user) { build(:user) }

    it "has expected content" do
      mail = UserMailer.with(user: user).user_not_covid_19_vaccinated
      expect(mail.to).to eq(['sarah@officemomsanddads.com'])
      expect(mail.subject).to eq("#{user} not vaccinated")
      expect(mail.body).to include(user.to_s)
    end
  end

  describe "shift_survey_submitted" do
    let(:shift_survey) { build_stubbed(:shift_survey) }

    it "has expected content" do
      mail = UserMailer.with(shift_survey: shift_survey).shift_survey_submitted
      expect(mail.to).to eq(['info@officemomsanddads.com'])
      expect(mail.subject).to eq("#{shift_survey.user} submitted a shift survey")
      expect(mail.body).to include(shift_survey.user.to_s)
    end
  end
end
