class SchedulerMailer < ApplicationMailer

  def send_updates(mailer_scheduler)
    @scheduler = mailer_scheduler
    @dataview = mailer_scheduler.dataview
    @scheduler.update(last_execution: Time.now)
    mail(
      to: @scheduler.user.email,
      subject: "Update for : #{@scheduler.name}"
    )
  end

end
