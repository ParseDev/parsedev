class MailerScheduler < ApplicationRecord
  belongs_to :dataview
  belongs_to :user

  def self.times
    [
      ['12:00 AM', "0"],
      ['01:00 AM', "60"],
      ['02:00 AM', "120"],
      ['03:00 AM', "180"],
      ['04:00 AM', "240"],
      ['05:00 AM', "300"],
      ['06:00 AM', "360"],
      ['07:00 AM', "420"],
      ['08:00 AM', "480"],
      ['09:00 AM', "540"],
      ['10:00 AM', "600"],
      ['11:00 AM', "660"],
      ['12:00 PM', "720"],
      ['01:00 PM', "780"],
      ['02:00 PM', "840"],
      ['03:00 PM', "900"],
      ['04:00 PM', "960"],
      ['05:00 PM', "1020"],
      ['06:00 PM', "1080"],
      ['07:00 PM', "1140"],
      ['08:00 PM', "1200"],
      ['09:00 PM', "1260"],
      ['10:00 PM', "1320"],
      ['11:00 PM', "1380"],

    ]
  end
  def test_scheduler
    GetSchedulerMailersJob.perform_async
  end
end
