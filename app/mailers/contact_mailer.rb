class ContactMailer < ApplicationMailer
  def new_contact_email(contact)
    @contact = contact
    mail(to: "elie@parse.dev", subject: "New Contact Created")
  end
end
