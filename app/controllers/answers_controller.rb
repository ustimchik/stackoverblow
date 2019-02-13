class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new(answer_params)
  end

  def edit
  end

  def create
    @answer = current_user.answers.create(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question, notice: "answer created"
    else
      render @answer.question
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question, notice: "answer updated"
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @question = @answer.question
      @answer.destroy
      redirect_to @question, notice: "answer deleted"
    else
      flash[:notice] = "You cannot delete answers of other users"
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
    params.require(:answer).permit(:title, :body)
  end
end
