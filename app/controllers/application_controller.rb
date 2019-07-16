class ApplicationController < ActionController::Base
  before_action :gon_user

  protect_from_forgery unless: -> { request.format.json? }

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js   { render json: { error: exception.message }, status: 403, content_type: 'application/json' }
      format.html { redirect_to root_url, notice: exception.message, status: :not_found }
      format.json   { render json: { error: exception.message }, status: 403, content_type: 'application/json' }
    end
  end

  check_authorization unless: :devise_controller?
end