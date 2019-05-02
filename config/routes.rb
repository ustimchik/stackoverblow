Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      post :markbest, on: :member
    end
  end
  resources :attachments do
    delete :destroy, on: :member
  end

  resources :users, only: [:show]

  root to: 'questions#index'
end
