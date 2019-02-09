class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.create(question_params)

    if @question.save
      redirect_to @question, notice: "question created"
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: "question updated"
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "question deleted"
    else
      flash[:notice] = "You cannot delete questions of other users"
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
