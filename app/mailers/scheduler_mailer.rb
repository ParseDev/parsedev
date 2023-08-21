class SchedulerMailer < ApplicationMailer

  def send_updates(mailer_scheduler)
    @scheduler = mailer_scheduler
    @dataview = mailer_scheduler.dataview
    mail(
      to: @scheduler.user.email,
      subject: "Update for : #{@scheduler.name}"
    )
  end

end
