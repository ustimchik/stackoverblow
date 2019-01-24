class AnswersController < ApplicationController

  before_action :set_question, only: [:index]

  def index
    @answers = Answer.where(question_id: @question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end