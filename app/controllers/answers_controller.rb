class AnswersController < ApplicationController

  before_action :set_question, only: [:index, :new]
  before_action :set_answer, only: [:show]

  def index
    @answers = Answer.where(question_id: @question)
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body, :question_id)
  end
end
