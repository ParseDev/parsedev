class HomeController < ApplicationController
  def index
    @layout = "landing"
    if user_signed_in?
      redirect_to new_chat_path
    end
  end
end
