# lib/tasks/daily_summary.rake

namespace :daily do
  desc "Send daily summary email"
  task :send_summary_email => :environment do
    DailySummaryMailer.summary_email.deliver_now
    puts "Daily summary email sent at #{Time.now}"
  end
end
