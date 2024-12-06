Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :feedbacks, except: [:index] do
    member do
      post :upvote, defaults: { format: :json }
      post :downvote, defaults: { format: :json }
    end
  end

  get 'feedbacks', to: 'home#feedbacks'

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update, :destroy]
    resources :feedbacks
    get 'dashboard', to: 'dashboard#index', as: :dashboard
  end
end
