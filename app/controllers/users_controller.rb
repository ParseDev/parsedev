# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @company = Company.find(params[:company_id])
    if @company === current_user.company
      @users = @company.users
    else
      redirect_to root_path, alert: "Oops, something went wrong"
    end
  end

  def new
  end

  def invite
    User.invite!({ email: params[:email], company: current_user.company }, current_user)
    redirect_to company_users_path(current_user.company, user_id: user.id), notice: "User invited!"
  end

  def resend_invitation
    user = User.find(params[:id], company_id: current_user.company.id)
    user.invite!
    redirect_to company_users_path(@company), notice: "Invitation resent."
  end
end
