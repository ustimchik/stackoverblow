class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show, :update, :destroy]
  before_action :set_question, only: [:index, :create]

  def index
    render json: @question.answers, each_serializer: AnswersCollectionSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = current_resource_owner.answers.create(answer_params.merge(question: @question))
    render json: { answer_id: @answer.id }, status: :created, content_type: 'application/json' if @answer.save
  end

  def update
    head :ok if @answer.update(answer_params)
  end

  def destroy
    head :ok if @answer.destroy
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