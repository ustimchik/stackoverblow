module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def upvote(user)
    vote(user, 1)
  end

  def downvote(user)
    vote(user, -1)
  end

  def clearvote(user)
    vote(user, 0)
  end

  def votescore
    self.votes.sum(:score)
  end

  def voted?(user)
    self.votes.where(user: user).exists?
  end

  def upvoted?(user)
    self.votes.where(user: user, score: 1).exists?
  end

  def downvoted?(user)
    self.votes.where(user: user, score: -1).exists?
  end

  private

  def vote(user, score)
    current_vote = votes.where(user: user)
    if current_vote.exists?
      current_vote.update(score: score)
    else
      votes.create(score: score, user: user)
    end
  end
end