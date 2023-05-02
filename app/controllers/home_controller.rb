class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if user_signed_in?
      redirect_to new_chat_path
    end
    @display_chat = true
  end
end
