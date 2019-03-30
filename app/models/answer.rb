class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def markbest
    question.answers.update_all(best: false)
    update!(best: true)
  end

end