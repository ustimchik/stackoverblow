class Services::QuestionUpdates
  def send_new_answer(answer)
    answer.question.subscriptions.each do |subscription|
      QuestionUpdatesMailer.send_new_answer(subscription.user, answer).deliver_later unless answer.user == subscription.user
    end
  end
end