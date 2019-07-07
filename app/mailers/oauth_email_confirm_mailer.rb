class OauthEmailConfirmMailer < ApplicationMailer
  default from: "from@example.com"

  def confirmation_email(email)
    mail(to: email, subject: 'Please confirm your email')
  end
end
