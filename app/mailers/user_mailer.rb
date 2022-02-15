# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'info@officemomsanddads.com'

  def notification_email
    @message = params[:message]
    mail(to: params[:email], subject: 'Volunteer Opportunity')
  end

  def user_not_covid_19_vaccinated
    @user = params[:user]
    mail(to: "sarah@officemomsanddads.com", subject: "#{@user} not vaccinated")
  end

  def shift_survey_submitted
    @shift_survey = params[:shift_survey]
    mail(to: "info@officemomsanddads.com", subject: "#{@shift_survey.user} submitted a shift survey")
  end
end
