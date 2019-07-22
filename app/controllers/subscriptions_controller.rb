class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    #I am not sure why, but this controller test won't run properly with just Ability, so added author_of check
    @subscription.destroy if current_user.author_of?(@subscription)
  end
end