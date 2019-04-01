class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  scope :best, -> { where(best: true) }
  scope :not_best, -> { where(best: false) }

  def markbest
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end