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
end
