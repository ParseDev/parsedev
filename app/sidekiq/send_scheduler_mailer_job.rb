class SendSchedulerMailerJob
  include Sidekiq::Job
  def perform(scheduler_mailer_id)
    scheduler = MailerScheduler.find(scheduler_mailer_id)
    SchedulerMailer.send_updates(scheduler).deliver_now
  end
end
