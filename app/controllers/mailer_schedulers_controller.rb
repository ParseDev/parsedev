class MailerSchedulersController < ApplicationController
  before_action :authenticate_user!

  def index
    @schedulers = current_user.mailer_schedulers.all
  end

  def show
  end

  def new
    @scheduler = current_user.mailer_schedulers.build
  end

  def create
    @scheduler = current_user.mailer_schedulers.build(mailer_scheduler_params)

    if @scheduler.save
      redirect_to mailer_schedulers_path, notice: "scheduler was successfully created."
    else
      flash[:alert] = @scheduler.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end
  def update

  end

  private

  def set_mailer_scheduler

  end

  def mailer_scheduler_params
    params.require(:mailer_scheduler).permit(:name, :send_time, :dataview_id)
  end


end
