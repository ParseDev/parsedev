class DataqueriesController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.id == dataquery_params[:user_id].try(:to_i)
      dataquery = Dataquery.new(dataquery_params)

      respond_to do |format|
        if dataquery.save
          # Set a flash message for successful creation
          flash[:notice] = "Query saved"
          # Render the JSON response with the dataquery object if it was successfully created
          format.json { render json: dataquery, status: :created }
          # Redirect to the same page for HTML format
          format.html { redirect_to dataquery_path(dataquery) }
        else
          # Set a flash message for unsuccessful creation
          flash[:alert] = "Oops, something went wrong"
          # Render an error message and a 401 status code if there was an issue creating the dataquery object
          format.json { render json: { error: "Unable to create dataquery" }, status: :unauthorized }
          # Redirect to the same page for HTML format
          format.html { redirect_to request.referrer }
        end
      end
    else
      # Set a flash message for unauthorized access
      flash[:alert] = "Unauthorized"
      # Render an error message and a 401 status code if the current_user's ID does not match the user_id in the params
      respond_to do |format|
        format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
        # Redirect to the same page for HTML format
        format.html { redirect_to request.referrer }
      end
    end
  end

  def edit
    @dataquery = current_user.dataqueries.find(params[:id])
    @result = @dataquery.run
  end

  def index
    @dataqueries = current_user.dataqueries.order(created_at: :desc)
  end

  def show
    @dataquery = current_user.dataqueries.find(params[:id])
    @result = @dataquery.run
  end

  def destroy
    dataquery = current_user.dataqueries.find(params[:id])
    dataquery.destroy!
    redirect_to dataqueries_path, notice: "Dataquery was successfully destroyed."
  end

  def download_csv
    @dataquery = current_user.dataqueries.find(params[:dataquery_id])
    result = @dataquery.run
    csv_data = CSV.generate(headers: true) do |csv|
      # Add headers to the CSV
      csv << result[0].keys

      # Add rows to the CSV
      result.each do |row|
        csv << row.values
      end
    end

    # Send the CSV data as a file
    send_data csv_data, type: "text/csv", filename: "data.csv"
  end

  def update
    @dataquery = current_user.dataqueries.find(params[:id])

    respond_to do |format|
      if @dataquery.update(dataquery_params)
        # Set a flash message for successful update
        flash[:notice] = "Query updated"
        # Render the JSON response with the dataquery object if it was successfully updated
        format.json { render json: @dataquery, status: :ok }
        # Redirect to the same page for HTML format
        format.html { redirect_to dataquery_path(@dataquery) }
      else
        # Set a flash message for unsuccessful update
        flash[:alert] = "Oops, something went wrong"
        # Render an error message and a 401 status code if there was an issue updating the dataquery object
        format.json { render json: { error: "Unable to update dataquery" }, status: :unauthorized }
        # Redirect to the same page for HTML format
        format.html { redirect_to request.referrer }
      end
    end
  end

  def run
    dataquery = current_user.dataqueries.find(params[:dataquery_id])
    dataquery.query = params[:query]
    result = dataquery.run
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("result_frame", partial: "/shared/result_table", locals: { answer: result, prompt: nil, include_create_chart_button: false }) }
    end
  end

  private

  def dataquery_params
    params.require(:dataquery).permit(:name, :query, :datasource_id, :user_id, :url, :request_method, :request_header, :request_body)
  end
end
