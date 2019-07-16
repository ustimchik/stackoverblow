class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show, :update, :destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    render json: { question_id: @question.id }, status: :created, content_type: 'application/json' if @question.save
  end

  def update
    head :ok if @question.update(question_params)
  end

  def destroy
    head :ok if @question.destroy
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy])
  end
end