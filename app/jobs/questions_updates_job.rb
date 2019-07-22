class QuestionsUpdatesJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    Services::QuestionUpdates.new.send_new_answer(answer)
  end
end