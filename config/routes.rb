Rails.application.routes.draw do
  
  
 
  get 'dashboard/index'

  resources :register_books
  devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions" }
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions" }
  # devise_scope :user do
  #     get 'sign_in', to: 'devise/sessions#new'
  #     get 'sign_up', to: 'devise/registrations#new'
  # end

  # authenticated :user do
  #   root 'vouchers#index', as: :authenticated_user
  # end

  authenticated :admin do
    root 'books#index', as: :authenticated_admin
  end

  resources :establishments
  resources :vouchers
  resources :books 

  resources :user do
    # get :make_moderator
    # get :make_normal_user
    delete 'user/:id' => 'user#destroy', :via => :delete #, :as => :admin_destroy_user
    get 'user/:id' => 'user#show', as: :user
  end

  # get 'user/index'
  # get 'user/show'   
  root 'establishments#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/sms', :to => 'sms#create'
      resources :sms, only: [:create]
      resources :users
    end
  end

end
