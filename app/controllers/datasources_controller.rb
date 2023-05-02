class DatasourcesController < ApplicationController
    before_action :authenticate_user!
    def new
        @datasource = Datasource.new
    end
    
    def create
        @datasource = Datasource.new(datasource_params.merge(company_id: current_user.try(:company_id) || 1))
        
        if @datasource.save
            redirect_to @datasource, notice: 'Datasource was successfully created.'
        else
            Rails.logger.warn @datasource.errors.full_messages.to_s
            render :new, notice: @datasource.errors.full_messages.to_s
        end
    end
    
    
    def index
        @datasources = Datasource.all
    end
    
    def show
        @datasource = Datasource.find(params[:id])
    end
    
    # private
    
    def datasource_params
        params.require(:datasource).permit(:name, :description, :datasource_type, :host, :port, :database_name, :database_username, :database_password)
    end
      
end