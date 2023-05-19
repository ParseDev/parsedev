class DataviewsController < ApplicationController
  before_action :authenticate_user!

  def show
    @dataview = Dataview.find(params[:id])
    redirect_to root_path, alert: "Oops something went wrong." unless @dataview.company == current_user.company
  end

  def new
    @dataview = Dataview.new
  end

  def create
    @dataview = Dataview.new(dataview_params)
    @dataview.company = current_user.company

    if @dataview.save
      redirect_to @dataview, notice: "Dataview was successfully created."
    else
      render :new
    end
  end

  def index
    @dataviews = current_user.company.dataviews
  end

  def destroy
    @dataview = Dataview.find(params[:id])
    if @dataview && @dataview.company == current_user.company
      @dataview.soft_destroy
      redirect_to dataviews_path, notice: "Dataview was successfully deleted."
    else
      redirect_to :back, alert: "Oops something went wrong."
    end
  end

  def create_dataquery
    @dataview = Dataview.find(params[:dataview_id])
    @dataquery = Dataquery.find(params[:dataquery_id])
    @dataview.dataqueries << @dataquery

    if @dataview.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("dataquery-form", partial: "dataviews/form", locals: { dataview: @dataview }), status: :unprocessable_entity }
      end
    end
  end

  private

  def dataview_params
    params.require(:dataview).permit(:name, :description)
  end
end
