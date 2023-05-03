class ChatsController < ApplicationController
  before_action :authenticate_user!
  def new
    @display_chat = true
  end
end
