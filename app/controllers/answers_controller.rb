class AnswersController < ApplicationController
  include VotesActions

  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :markbest]
  before_action :set_question, only: [:update, :destroy, :markbest]
  after_action :stream_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def markbest
    @answer.markbest if current_user.author_of?(@question)
  end

  private

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end

  def stream_answer
    return if @answer.errors.any?
    attachments = @answer.files.map do |attachment|
      { id: attachment.id, filename: attachment.filename, url: url_for(attachment) }
    end
    data = @answer.as_json.merge(attachments: attachments)
    data['question_user_id'] = @answer.question.user.id
    ActionCable.server.broadcast("question_#{@answer.question.id}", data: data)
  end

  def answer_params
    params.require(:answer).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end