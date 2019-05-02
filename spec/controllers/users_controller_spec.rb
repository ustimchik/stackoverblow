require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #show' do
    let (:user) { create(:user) }
    let (:other_user) { create(:user) }

    context 'as logged in user' do
      before { login(user) }

      context 'viewing own account' do
        before { get :show, params: {id: user} }

        it 'sets @user variable' do
          expect(assigns(:user)).to eq user
        end

        it 'renders show html' do
          expect(response).to render_template :show
        end
      end
      context 'viewing some other account' do
        before { get :show, params: {id: other_user} }

        it 'sets @user variable' do
          expect(assigns(:user)).to eq other_user
        end

        it 'renders aboutuser html' do
          expect(response).to render_template :aboutuser
        end
      end
    end

    context 'as NOT logged in user' do
      before { get :show, params: {id: user} }

      it 'does not set @user variable' do
        expect(assigns(:user)).to_not eq user
      end

      it 'does not render show html' do
        expect(response).to_not render_template :show
      end

      it 'does not render aboutuser html' do
        expect(response).to_not render_template :about_user
      end
    end

  end
end