class DatasourcesController < ApplicationController
  before_action :authenticate_user!

  def new
    @datasource = Datasource.new
  end

  def create
    @datasource = Datasource.new(datasource_params.merge(company_id: current_user.try(:company_id) || 1))
    begin
      tunnel = SshGatewayService.new(@datasource.host, @datasource.port).intiat_connection    
      @datasource.connection(tunnel[1])
      tunnel[0].shutdown!
    rescue
      redirect_to new_datasource_path, alert: "Could not establish connection to datasource. Please make sure that you use correct credentials." and return true
    end
    if @datasource.save
      redirect_to @datasource, notice: "Datasource was successfully created."
    else
      Rails.logger.warn @datasource.errors.full_messages.to_s
      render :new, alert: @datasource.errors.full_messages.to_s
    end
  end

  def index
    @datasources = current_user.company.datasources
  end

  def edit
    @datasource = Datasource.find(params[:id])
  end

  def update
    @datasource = Datasource.find(params[:id])
    if @datasource.company == current_user.company
      if @datasource.update(datasource_params)
        redirect_to @datasource, notice: "Datasource was successfully updated."
      else
        redirect_to datasources_path, alert: "Oops something went wrong."
      end
    else
      redirect_to datasources_path, alert: "Oops something went wrong."
    end
  end

  def show
    @datasource = Datasource.find(params[:id])
    @tunnel = SshGatewayService.new(@datasource.host, @datasource.port).intiat_connection    
  end

  def destroy
    @datasource = Datasource.find(params[:id])
    if @datasource.company == current_user.company
      @datasource.soft_destroy
      redirect_to datasources_path, notice: "Datasource was successfully destroyed."
    else
      redirect_to datasources_path, alert: "Oops something went wrong."
    end
  end

  # private

  def datasource_params
    params.require(:datasource).permit(:name, :description, :datasource_type, :host, :port, :database_name, :database_username, :database_password, :swagger_url, :api_key)
  end
end
