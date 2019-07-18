class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  protect_from_forgery with: :null_session

  def current_user
    current_resource_owner
  end

  private

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def handle_not_found(e)
    render json: { error: e.to_s }, status: 404
  end
end