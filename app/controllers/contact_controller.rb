class ContactController < ApplicationController
  def new
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      flash[:notice] = "Thank you for your interest in ParseDev! We will be in touch soon."
      redirect_to "https://calendly.com/elie-parse/30min"
    else
      flash[:alert] = "There was a problem submitting your request. Please try again."
      redirect_to beta_path
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :company_name, :number_of_employees, :database_support)
  end
end
