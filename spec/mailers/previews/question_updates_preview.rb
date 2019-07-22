# Preview all emails at http://localhost:3000/rails/mailers/question_updates
class QuestionUpdatesPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/question_updates/send_new_answer
  def send_new_answer
    QuestionUpdatesMailer.send_new_answer
  end

end
