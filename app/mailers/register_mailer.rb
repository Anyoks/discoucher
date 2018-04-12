class RegisterMailer < ApplicationMailer
	default from: "anyoksmoks@gmail.com"

	def registration_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
