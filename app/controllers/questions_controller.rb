class QuestionsController < ApplicationController
  include VotesActions

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  after_action :stream_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    gon.question_id = @question.id
    gon.question_user_id = @question.user.id
  end

  def new
    @question = Question.new
    @question.award = Award.new
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
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: "question deleted"
    else
      redirect_to @question, notice: "You cannot delete questions of other users"
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
  end

  def stream_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', ApplicationController.render(partial: 'questions/question_item', locals: { question: @question }))
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], award_attributes: [:id, :name, :image])
  end
end
