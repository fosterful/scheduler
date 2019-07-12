# frozen_string_literal: true

namespace :cleanup do
  JUMPSTART_TASK    = 'cleanup:jumpstart'
  RUBOCOP_TASK      = 'cleanup:rubocop'
  ALL_CLEANUP       = [JUMPSTART_TASK, RUBOCOP_TASK].freeze
  COMMAND_PREFIX    = 'RAILS_ENV=test bundle exec'
  JUMPSTART_COMMAND = 'rspec-jumpstart -r -f app'
  RUBOCOP_COMMAND   = 'rubocop --auto-correct'

  desc 'Run all cleanup commands'
  task all: :environment do
    ALL_CLEANUP.each do |task|
      Rake::Task[task].invoke
    end
  end

  desc 'Generate missing specs'
  task jumpstart: :environment do
    run_cleanup(JUMPSTART_TASK, JUMPSTART_COMMAND)
  end

  desc 'Rubocop cleanup'
  task rubocop: :environment do
    run_cleanup(RUBOCOP_TASK, RUBOCOP_COMMAND)
  end

  private

  def run_cleanup(task, command)
    puts "Starting #{task}"
    system("#{COMMAND_PREFIX} #{command}")
    puts "Finishing #{task}"
  end

end
