class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_question, only: [:index, :create]

  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswersCollectionSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question: @question))
    if @answer.save
      render json: { answer_id: @answer.id }, status: :created
    else
      render json: { error: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      head :ok
    else
      render json: { error: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy])
  end
end