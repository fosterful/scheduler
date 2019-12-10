class VerificationsController < ApplicationController
  VERIFY_SID = Rails.application.credentials.twilio[:verify_sid]

  def index
  end

  def send_code
    $twilio.verify.services(VERIFY_SID).verifications.
      create(to: twilio_phone_number, channel: 'sms')
    flash[:notice] = 'Verification code has been sent'
    redirect_to verify_path
  end

  def check_code
    params.permit(:code)
    code = params[:code]
    check = $twilio.verify.services(VERIFY_SID).verification_checks.
      create(to: twilio_phone_number, code: code)
    if check.status == 'approved'
      current_user.update(verified: true)
      flash[:notice] = 'Phone number has been verified!'
    else
      flash[:notice] = 'Verification failed'
    end
    redirect_to verify_path
  end

  private

  def twilio_phone_number
    '+1' + current_user.phone.gsub(/\D/, '')
  end
end
