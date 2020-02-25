class PreVerifyEligibleUsers < ActiveRecord::Migration[6.0]
  def up
    return unless Rails.env.production?
    User.where.not(phone: nil).find_each do |user|
      begin
        messages = $twilio.messages.list(to: user.phone, limit: 100)
        messages.select! { |m| m.status == 'delivered'}
        if messages.any?
          user.update! verified: true
          puts "marked user #{user.id} as verified"
        else
          puts "could not find delivered message for #{user.id}"
        end
      rescue Exception => e
        puts "error while processing user #{user.id}: #{e}"
      end
    end
  end
end
