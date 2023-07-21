class CronController < ApplicationController
  SAFETY_LOCK = "hey_whats_up"

  def dailysummary
    if params[:secret_key] == SAFETY_LOCK
      DailySummaryMailer.summary_email.deliver_now!
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
end
