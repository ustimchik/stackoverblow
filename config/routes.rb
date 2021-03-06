require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin?  } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
    resources :subscriptions, only: [:create, :destroy], shallow: true
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
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :create]
      end
      resources :answers, only: [:show, :update, :destroy]
    end
  end

  get 'search', to: 'search#new'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end