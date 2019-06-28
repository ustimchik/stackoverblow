class ApplicationController < ActionController::Base
  before_action :gon_user

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
