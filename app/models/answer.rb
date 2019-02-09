class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :title, :body, presence: true
end
