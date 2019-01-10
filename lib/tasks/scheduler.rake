namespace :scheduler do
  desc "This task is called by the Heroku scheduler add-on"
  task :update_block_outs => :environment do
    Rails.logger.info("Updating #{BlockOut.current_recurring.count} BlockOuts")
    BlockOut.current_recurring.find_each do |block_out|
      Services::ExpandRecurringBlockOut.call(block_out)
    end

    # Clean up a day after the last occurrence
    BlockOut.joins(:parent).where('parents_block_outs.last_occurrence < ?', Time.zone.now.beginning_of_day).delete_all
  end
end
