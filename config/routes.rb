Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  as :user do
    post "oauth_sign_up", to: "oauth_callbacks#send_confirmation"
  end

  concern :voteable do
    post :upvote, on: :member
    post :downvote, on: :member
    post :clearvote, on: :member
  end

  resources :questions, concerns: [:voteable] do
    resources :comments, shallow: true
    resources :answers, concerns: [:voteable], shallow: true do
      post :markbest, on: :member
      resources :comments, shallow: true
    end
  end
  resources :attachments do
    delete :destroy, on: :member
  end

  resources :users, only: [:show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update] do
        delete :destroy, on: :member
        resources :answers, only: [:index, :create]
      end
      resources :answers, only: [:show, :update] do
        delete :destroy, on: :member
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end