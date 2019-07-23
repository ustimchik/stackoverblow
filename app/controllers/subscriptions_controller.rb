class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    authorize! :create, Subscription
    @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription
    @subscription.destroy
  end
end