class Question < ApplicationRecord
  include Voteable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :voteable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :subscriptions, dependent: :destroy

  has_one :award, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create -> {subscribe(self.user)}

  def subscribe(user)
    self.subscriptions.create(user: user)
  end
end