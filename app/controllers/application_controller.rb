class ApplicationController < ActionController::Base
  layout :determine_layout

  private

  def determine_layout
    return @layout if @layout
    current_user ? "application" : "devise"
  end
end
