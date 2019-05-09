Rails.application.routes.draw do
  devise_for :users

  concern :voteable do
    post :upvote, on: :member
    post :downvote, on: :member
    post :clearvote, on: :member
  end

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable], shallow: true do
      post :markbest, on: :member
    end
  end
  resources :attachments do
    delete :destroy, on: :member
  end

  resources :users, only: [:show]

  root to: 'questions#index'
end