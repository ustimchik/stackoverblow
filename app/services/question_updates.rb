class Services::QuestionUpdates
  def send_new_answer(answer)
    answer.question.subscriptions.each do |subscription|
      user = subscription.user
      QuestionUpdatesMailer.send_new_answer(user, answer).deliver_later unless answer.user.author_of?(subscription)
    end
  end
end