class Services::QuestionUpdates
  def send_new_answer(answer)
    answer.question.subscriptions.each do |subscription|
      QuestionUpdatesMailer.send_new_answer(subscription.user, answer).deliver_later unless answer.user.author_of?(subscription)
    end
  end
end