# app/controllers/users_controller.rb
class UsersController < ApplicationController
    before_action :authenticate_user!
    def index
      @company = Company.find(params[:company_id])
      if @company === current_user.company
        @users = @company.users
      else
        redirect_to root_path, alert: 'Oops, something went wrong'
      end
    end

    def new
    end

    def invite
        debugger
    end
  end