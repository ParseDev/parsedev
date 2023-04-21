class Users::RegistrationsController < Devise::RegistrationsController
    def create
        build_resource(sign_up_params)
    
        # Create a new company with the provided name
        company = Company.new(name: sign_up_params[:company_name])
        puts "company name: #{company.name}"
    
        # Save the company
        if company.save
          # Associate the company with the user
          resource.company = company
    
          # Continue with the normal Devise registration process
          super
        else
          # Handle the error (e.g., display an error message)
          # You can customize the error message based on your application's requirements
          flash[:alert] = "Failed to create company. Please try again."
          render :new
        end
      end


    private
  
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :company_name)
    end
  
  end