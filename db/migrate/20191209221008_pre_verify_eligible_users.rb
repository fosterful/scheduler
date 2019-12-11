class PreVerifyEligibleUsers < ActiveRecord::Migration[6.0]
  def up
    User.where.not(phone: nil).find_each do |user|
      begin
        messages = $twilio.messages.list(to: user.phone, limit: 100)
        messages.each do |m|
          if m.status == 'delivered'
            user.update! verified: true
            puts "marked user #{user.id} as verified"
            break
          end
        end
        puts "could not find delivered message for #{user.id}"
      rescue Exception => e
        puts "error while processing user #{user.id}: #{e}"
      end
    end
  end
end
