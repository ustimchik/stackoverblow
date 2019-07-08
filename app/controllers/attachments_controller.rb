class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge_later if current_user.author_of?(@attachment.record)
  end
end