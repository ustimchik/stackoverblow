class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @question = Question.find(params[:question])
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge_later if current_user.author_of?("#{@attachment.record_type}".constantize.find(@attachment.record_id))
  end
end