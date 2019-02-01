credentials = Rails.application.credentials.twilio || {}

$twilio = Twilio::REST::Client.new(credentials[:account_sid], credentials[:auth_token])
