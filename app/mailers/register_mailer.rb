class RegisterMailer < ApplicationMailer
	default from: "anyoksdenn@gmail.com"

	def registration_email
    @user = param [:user]
    mail(to: @user.email, subject: 'Sample Email')
  end
end
