class DataviewsController < ApplicationController
  def show
    @dataview = Dataview.find(params[:id])
    redirect_to root_path, alert: "Oops something went wrong." unless @dataview.company == current_user.company
  end

  def index
    @dataviews = current_user.company.dataviews
  end
end
