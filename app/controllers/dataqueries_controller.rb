class DataqueriesController < ApplicationController
  before_action :authenticate_user!
  def create
    if current_user.id == dataquery_params[:user_id].try(:to_i)
      dataquery = Dataquery.new(dataquery_params)
  
      respond_to do |format|
        if dataquery.save
          # Set a flash message for successful creation
          flash[:notice] = 'Query saved'
          # Render the JSON response with the dataquery object if it was successfully created
          format.json { render json: dataquery, status: :created }
          # Redirect to the same page for HTML format
          format.html { redirect_to dataquery_path(dataquery) }
        else
          # Set a flash message for unsuccessful creation
          flash[:alert] = 'Oops, something went wrong'
          # Render an error message and a 401 status code if there was an issue creating the dataquery object
          format.json { render json: { error: 'Unable to create dataquery' }, status: :unauthorized }
          # Redirect to the same page for HTML format
          format.html { redirect_to request.referrer }
        end
      end
    else
      # Set a flash message for unauthorized access
      flash[:alert] = 'Unauthorized'
      # Render an error message and a 401 status code if the current_user's ID does not match the user_id in the params
      respond_to do |format|
        format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
        # Redirect to the same page for HTML format
        format.html { redirect_to request.referrer }
      end
    end
  end
  
  
  def index
    @dataqueries = current_user.dataqueries
  end

  def show
    @dataquery = current_user.dataqueries.find(params[:id])
    @result = @dataquery.run
  end

  def destroy
    dataquery = current_user.dataqueries.find(params[:id])
    dataquery.destroy!
    redirect_to dataqueries_path, notice: 'Dataquery was successfully destroyed.'
  end

  private
  def dataquery_params 
    params.require(:dataquery).permit(:name, :query, :datasource_id, :user_id)
  end
end
