class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  scope :best, -> { where(best: true) }
  scope :not_best, -> { where(best: false) }

  def markbest
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award.update!(user: self.user) if question.award
    end
  end
end