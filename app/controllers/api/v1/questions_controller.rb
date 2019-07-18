class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsCollectionSerializer
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    if @question.save
      render json: { question_id: @question.id }, status: :created, content_type: 'application/json'
    else
      render json: { error: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      head :ok
    else
      render json: { error: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:id, :name, :url, :_destroy])
  end
end