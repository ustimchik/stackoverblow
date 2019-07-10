class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  protected

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, ActiveStorage::Attachment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, ActiveStorage::Attachment do |attachment|
      @user.author_of?(attachment.record)
    end
    can :markbest, Answer do |answer|
      @user.author_of?(answer.question) && !@user.author_of?(answer)
    end
    can [:upvote, :downvote, :clearvote], [Question, Answer] do |item|
      !@user.author_of?(item)
    end
  end
end