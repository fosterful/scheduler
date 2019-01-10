namespace :scheduler do
  desc "This task is called by the Heroku scheduler add-on"
  task :update_blockouts => :environment do
    Rails.logger.info("Updating #{Blockout.current_recurring.count} Blockouts")
    Blockout.current_recurring.find_each do |blockout|
      Services::ExpandRecurringBlockout.call(blockout)
    end

    # Clean up a day after the last occurrence
    Blockout.joins(:parent).where('parents_blockouts.last_occurrence < ?', Time.zone.now.beginning_of_day).delete_all
  end
end
