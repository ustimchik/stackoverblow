class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  def best_answer
    answers.where(best: true)
  end

  def other_answers
    answers.where(best: false)
  end
end