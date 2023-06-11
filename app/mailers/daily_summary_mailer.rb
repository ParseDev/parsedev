class DailySummaryMailer < ApplicationMailer
  default to: "elie@parse.dev", subject: "Parse Daily Summary"

  def summary_email()
    @new_signups = User.where("created_at >= ?", 1.day.ago).count
    @new_prompts = Prompt.where("created_at >= ?", 1.day.ago).count
    mail
  end
end
