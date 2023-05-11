class ChatsController < ApplicationController
  before_action :authenticate_user!

  def new
    if current_user.company.datasources.count == 0
      redirect_to new_datasource_path, notice: "Please connect a datasource to start chatting."
    else
      @display_chat = true
    end
  end
end
