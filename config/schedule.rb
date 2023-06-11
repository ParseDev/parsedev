every 1.day, at: "9:00 am" do
  runner "DailySummaryMailer.summary_email.deliver_now"
end
