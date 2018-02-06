Rails.application.routes.draw do
  
  

  devise_for :users
  devise_scope :user do
      get 'sign_in', to: 'devise/sessions#new'
      get 'sign_up', to: 'devise/registrations#new'
  end

  authenticated :user do
    root to: 'book#index', as: :authenticated_root
  end


  resources :establishments
  resources :vouchers
  resources :books
  # root 'establishments#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
