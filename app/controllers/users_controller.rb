class UsersController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check

  def show
    @user = User.find(params[:id])
    render 'aboutuser' if @user != current_user
  end

end