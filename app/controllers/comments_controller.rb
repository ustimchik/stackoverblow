class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_comment, only: [:update, :destroy]
  before_action :set_commentable
  after_action :stream_comment, only: [:create]

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    @css = set_css
  end

  def update
    @comment.update(comment_params) if current_user.author_of?(@comment)
    @css = set_css
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def stream_comment
    return if @comment.errors.any?
    data = @comment.as_json.merge(user_email: @comment.user.email)
    data['created_at'] = data['created_at'].to_formatted_s(:short)
    question_id = (params[:question_id]).present? ? params[:question_id] : @commentable.question.id
    ActionCable.server.broadcast("comments_question_#{question_id}", data: data)
  end

  def set_commentable
    @commentable = Question.find(params[:question_id]) if (params[:question_id]).present?
    @commentable = Answer.find(params[:answer_id]) if (params[:answer_id]).present?
  end

  def set_css
    @commentable.instance_of?(Answer) && @commentable.best? ? ".answer-best" : ".#{@comment.commentable_type.downcase}"
  end

  def comment_params
    params.require(:comment).permit(:body, :question_id, :answer_id)
  end
end
