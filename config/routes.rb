Rails.application.routes.draw do
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

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end