credentials = Rails.application.credentials.twilio || { account_sid: ENV['TWILIO_ACCOUNT_SID'], auth_token: ENV['TWILIO_AUTH_TOKEN']}

$twilio = Twilio::REST::Client.new(credentials[:account_sid], credentials[:auth_token])
