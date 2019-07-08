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
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :markbest, Answer do |answer|
      answer.question.user == @user && !@user.author_of?(answer)
    end
    can :upvote, [Question, Answer] do |item|
      !@user.author_of?(item)
    end
    can :downvote, [Question, Answer] do |item|
      !@user.author_of?(item)
    end
    can :clearvote, [Question, Answer] do |item|
      !@user.author_of?(item)
    end
  end
end
