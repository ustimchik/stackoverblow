class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]

  def create
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer.question, notice: "answer updated"
    else
      render :edit
    end
  end

  def destroy
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: "answer deleted"
    else
      redirect_to @question, notice: "You cannot delete answers of other users"
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
