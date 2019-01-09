desc "This task is called by the Heroku scheduler add-on"
task :update_block_outs => :environment do
  puts "Updating ${BlockOut.current_recurring.count} BlockOuts"
  BlockOut.current_recurring.find_each do |block_out|
    ExpandRecurringBlockOut.call(block_out)
  end
end