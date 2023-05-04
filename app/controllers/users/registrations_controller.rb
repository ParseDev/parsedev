class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    # Use a transaction block to ensure that both the company and user are saved together
    ActiveRecord::Base.transaction do
      # Create a new company with the provided name
      company = Company.new(name: sign_up_params[:company_name])
      puts "company name: #{company.name}"

      # Save the company
      if company.save
        # Associate the company with the user
        resource.company = company
        if !resource.save
          # If the user fails to save, raise an exception to trigger a rollback
          raise ActiveRecord::Rollback, "Failed to save user"
        else
          sign_in(resource)
          flash[:notice] = "Welcome #{resource.email}!"
          respond_with resource, location: after_sign_up_path_for(resource)
        end
      else
        # Handle the error (e.g., display an error message)
        # You can customize the error message based on your application's requirements
        flash[:alert] = "Failed to create company. Please try again."
        render :new
        # Raise an exception to trigger a rollback
        raise ActiveRecord::Rollback, "Failed to create company"
      end
    end

    # Check if the user was saved successfully
    unless resource.persisted?
      # If the user was not saved, handle the error (e.g., display an error message)
      flash[:alert] = resource.errors.full_messages.to_sentence
      redirect_to :new_user_registration
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :company_name)
  end
end
