class QuestionUpdatesMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_updates_mailer.send_new_answer.subject
  #
  def send_new_answer(user, answer)
    @greeting = "Dear Stackoverblow member!"
    @answer = answer

    mail(to: user.email, subject: "A new answer was added")
  end
end
