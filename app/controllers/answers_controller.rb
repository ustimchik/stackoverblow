class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :markbest]

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def update
    @question = @answer.question
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
  end

  def markbest
    @question = @answer.question
    @answer.markbest if current_user.author_of?(@question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end