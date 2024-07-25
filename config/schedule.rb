# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
env :PATH, ENV['PATH']
set :output, 'log/cron_log.log'
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

#commands
#convert: bundle exec whenever
#Clear: crontab -r
#List: crontab -l
#clear and update: bundle exec whenever --clear-crontab
#update: bundle exec whenever --update-crontab
#update cron:  bundle exec whenever --update-crontab --set environment='production'
#update cron: bundle exec whenever --update-crontab --set environment='development'


every 1.minute do
  runner 'NewMonthBalanceJob.perform_later'
end
