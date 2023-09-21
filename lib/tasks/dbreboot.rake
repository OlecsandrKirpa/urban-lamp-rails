# frozen_string_literal: true

# Call this task with 'rails db:reboot' or 'rails db:reboot[seed]'
namespace :db do
  task :reboot, [:seed] do |_, args|
    puts %(This task will drop current databse and re-create it.)
    raise %(#{sep = "#{'*' * 50}\n"}This task is avaliable only in development.\n#{sep}) if Rails.env.production?

    queue = %w[drop create migrate]

    if %w[seed seeds].include?(args[:seed])
      puts 'Seed will be called too.'
      queue << 'seed'
    else
      puts 'To call seed at the end of the execution, use "rails db:reboot[seed]"'
    end

    sleep 1

    execute_queue(queue)
  end
end

def execute_queue(queue)
  raise 'This task is avaliable only in development' if Rails.env.production?

  queue.each do |task|
    Rake::Task["db:#{task}"].invoke
  end
end
