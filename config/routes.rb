Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  resources :teams do
    resources :memberships, only: %i[create destroy]
    resources :projects, only: %i[new create]
  end

  resources :projects, only: %i[show edit update destroy] do
    resources :tasks, only: %i[new create]
  end

  resources :tasks, only: %i[show edit update destroy] do
    resources :comments, only: %i[create], constraints: { format: :turbo_stream }
    resources :comments, only: %i[create]
  end
end
