Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  root 'welcome#index'
  resources :users do
    collection do
      post :restore_record
    end
  end
  resources :permissions do
    collection do
      post :restore_record
    end
  end
  resources :roles do
    collection do
      post :restore_record
    end
  end
  resources :posts do
    collection do
      post :restore_record
    end
  end

  get 'password/reset', to:"password_reset#new"
  post 'password/reset', to:"password_reset#create"
  get 'password/reset/edit', to:"password_reset#edit"
  put 'password/reset/edit', to:"password_reset#update"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
