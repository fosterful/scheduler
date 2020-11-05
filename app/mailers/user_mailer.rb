
class UserMailer < ApplicationMailer
  default from: 'info@officemomsanddads.com'
 
  def notification_email
    @message = params[:message]
    mail(to: params[:email], subject: 'Volunteer Opportunity')
  end
end