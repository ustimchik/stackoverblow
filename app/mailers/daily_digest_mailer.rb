class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user, daily_questions)
    @greeting = "Dear Stackoverblow member!"
    @daily_questions = daily_questions

    mail(to: user.email, subject: "Questions created for the past day")
  end
end