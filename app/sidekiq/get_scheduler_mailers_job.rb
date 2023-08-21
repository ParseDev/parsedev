class GetSchedulerMailersJob
  include Sidekiq::Job
  def perform(*args)
    schedulers = MailerScheduler.where(send_time: Time.now.strftime('%H').to_i * 60)
    schedulers.each do |s|
      SendSchedulerMailerJob.perform_async(s.id)
    end
  end
end
