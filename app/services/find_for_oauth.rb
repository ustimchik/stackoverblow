class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization.user if authorization
    return unless email = auth.dig(:info, :email)
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth[:provider], uid: auth[:uid].to_s)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      if auth.dig(:info, :need_confirmation)
        user.send_confirmation_instructions
      else
        user.skip_confirmation!
      end
      user.save!
      user.authorizations.create(provider: auth[:provider], uid: auth[:uid].to_s)
    end
    user
  end
end