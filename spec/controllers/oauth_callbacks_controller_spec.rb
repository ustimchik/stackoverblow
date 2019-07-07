require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '.social_network_login' do
    let(:oauth_data) { {'provider': 'github', 'uid': '123545'} }

    it 'calls find for auth method on User' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user returned and persisted' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        get :github
      end

      it 'logs in user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not returned' do
      before do
        allow(User).to receive(:find_for_oauth)
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        get :github
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'sets uid and provider from callback to session[:auth]' do
        expect(request.session[:auth]).to eq({ uid: '123545', provider: 'github' })
      end

      it 'renders email input form' do
        expect(response).to render_template 'common/oauth_email_confirmation'
      end
    end
  end

end