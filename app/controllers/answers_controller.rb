class AnswersController < ApplicationController

  before_action :set_question, only: [:index, :new, :create]
  before_action :set_answer, only: [:show, :edit]

  def index
    @answers = Answer.where(question_id: @question)
  end

  def show
  end

  def new
    @answer = @question.answers.new(answer_params)
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @answer, notice: "answer created"
    else
      render :new
    end
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
