Rails.application.routes.draw do
  
  require 'sidekiq/web'
  
 
  

  
  devise_for :admins, path: 'admins', controllers: { sessions: "admins/sessions" }
  # devise_for :users, path: 'users', controllers: { sessions: "users/sessions" }
  # devise_scope :user do
  #     get 'sign_in', to: 'devise/sessions#new'
  #     get 'sign_up', to: 'devise/registrations#new'
  # end

  # authenticated :user do
  #   root 'vouchers#index', as: :authenticated_user
  # end

  authenticated :admin do
    mount Sidekiq::Web => '/sidekiq'
    root 'admin/dashboard#index', as: :authenticated_admin
  end


  namespace :admin do
    get 'dashboard/index'
    get '/search', :to => 'search#search'
    resources :register_books
    resources :establishments  do
      resources :pictures
    end
    resources :vouchers
    resources :books do 
      get '/search', :to => 'search#search'
    end

    resources :user do
      # get :make_moderator
      # get :make_normal_user
      delete 'user/:id' => 'user#destroy', :via => :delete #, :as => :admin_destroy_user
      get 'user/:id' => 'user#show', as: :user
    end
  end
  get '/register', :to => "admin/register_books#new"
  
  root 'admin/dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # devise_for :users , path: 'users', controllers: { sessions: "users/sessions" }
      get '/sms', :to => 'sms#create'
      get '/profile', :to => 'profile#profile'
      get '/establishments/est'

      get '/establishments/hotels'
      get '/establishments/restaurants'
      get '/establishments/spas'
      post '/establishments/get_est'

      get '/vouchers/all' #all vouchers
      post '/vouchers/est', :to => 'vouchers#show_for_establishment' #for a particular establishment
      get '/establishment_type/all'

      post '/favourites/add', :to => 'profile#add_favourite'
      get 'favourites', :to => 'profile#all' 

      post '/search/vouchers'

      resources :sms, only: [:create]
      mount_devise_token_auth_for 'User', at: 'auth'
      # resources :users
    end
  end

end
