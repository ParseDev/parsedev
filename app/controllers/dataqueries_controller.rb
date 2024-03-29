class DataqueriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dataquery, only: [:show, :edit, :update, :destroy, :download_csv, :execute, :run]

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
    @result = @dataquery.run
  end

  def test
    datasource = Datasource.find(params[:datasource_id])
    unless datasource.company == current_user.company
      redirect_to dataqueries_path, alert: "Oops something went wrong."
      return
    end

    @dataquery = Dataquery.new(datasource: datasource, query: params[:query])

    begin
      @result = @dataquery.run
    rescue => e
      # Handle the exception here
      @error_message = e.message
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("test_result", partial: "/shared/error", locals: { error_message: @error_message }) }
        format.html { render :show, alert: @error_message }
      end
      return
    end

    respond_to do |format|
      if @dataquery.datasource.datasource_type == "psql" || @dataquery.datasource.datasource_type == "mysql"
        format.turbo_stream { render turbo_stream: turbo_stream.update("test_result", partial: "/shared/result_table", locals: { answer: @result, prompt: nil, include_create_chart_button: false }) }
        format.html { render :show }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.update("test-result", partial: "/shared/code", locals: { code: @result }) }
        format.html { render :show }
      end
    end
  end

  def index
    @dataqueries = current_user.company.users.map { |user| user.dataqueries }.flatten.sort_by(&:created_at).reverse
  end

  def show
    @result = @dataquery.run
  end

  def new
    @dataquery = Dataquery.new
    @datasources = current_user.company.datasources
    if @datasources.empty?
      redirect_to new_datasource_path, notice: "Please create a datasource first."
    end
  end

  def destroy
    @dataquery.destroy!
    redirect_to dataqueries_path, notice: "Dataquery was successfully destroyed."
  end

  def download_csv
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

  def execute
    @result = @dataquery.run

    respond_to do |format|
      if @dataquery.datasource.datasource_type == "psql" || @dataquery.datasource.datasource_type == "mysql"
        format.turbo_stream { render turbo_stream: turbo_stream.update(@dataquery.frame_id, partial: "/shared/result_table", locals: { answer: @result, prompt: nil, include_create_chart_button: false }) }
        format.html { render :show }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.update(@dataquery.frame_id, partial: "/shared/code", locals: { code: @result }) }
        format.html { render :show }
      end
    end
  end

  def run
    if params[:query].present?
      @dataquery.query = params[:query]
    end
    @result = @dataquery.run

    respond_to do |format|
      if @dataquery.datasource.datasource_type == "psql" || @dataquery.datasource.datasource_type == "mysql"
        format.turbo_stream { render turbo_stream: turbo_stream.update(@dataquery.frame_id, partial: "/shared/result_table", locals: { answer: @result, prompt: nil, include_create_chart_button: false }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.update(@dataquery.frame_id, partial: "/shared/code", locals: { code: @result }) }
      end
    end
  end

  private

  def dataquery_params
    params.require(:dataquery).permit(:name, :query, :datasource_id, :user_id, :url, :request_method, :request_header, :request_body)
  end

  def set_dataquery
    dataquery_id = params[:dataquery_id] || params[:id]
    if dataquery_id
      @dataquery = Dataquery.find(dataquery_id)
      redirect_to dataqueries_path, alert: "Oops something went wrong." unless @dataquery.user.company == current_user.company
    end
  end
end
