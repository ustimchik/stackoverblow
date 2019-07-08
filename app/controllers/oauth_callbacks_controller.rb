class OauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :social_network_login, only: [:github, :twitter, :send_confirmation]

  skip_authorization_check

  def github
  end

  def twitter
  end

  def send_confirmation
    session[:auth] = nil
  end

  def social_network_login
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: @auth[:provider]) if is_navigational_format?
    else
      flash[:notice] = 'Please enter e-mail to complete registration'
      session[:auth] = { uid: @auth[:uid], provider: @auth[:provider] }
      render 'common/oauth_email_confirmation'
    end
  end

  private

  def auth
    @auth = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params_auth)
  end

  def params_auth
    params_auth = {auth: OmniAuth::AuthHash::InfoHash.new()}
    params_auth[:auth] = session[:auth].merge(info: {email: params[:email], need_confirmation: true})
  end
end
