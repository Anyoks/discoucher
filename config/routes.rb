Rails.application.routes.draw do
  
  
  namespace :admin do
    resources :payment_responses
  end
  namespace :admin do
    resources :payment_requests
  end
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
    resources :reviews
    resources :establishment_types do
      get :activate_deactivate_type
    end
    resources :vouchers do
      resources :tags_vouchers
      # get :show_voucher_tags, :to => 'tags#show_voucher_tags'
      # get :create_voucher_tags, :to => 'tags#create_voucher_tags'
    end
    resources :tags
    resources :tags do
      resources :tagpics
    end
    resources :books do 
      get '/search', :to => 'search#search'
    end
   
    resources :users do
      get :mark_as_paid
      get :mark_as_unpaid
    end
  end
  get '/register', :to => "admin/register_books#new"
  
  root 'admin/dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do
      # devise_for :users , path: 'users', controllers: { sessions: "users/sessions" }
      get '/sms', :to => 'sms#create'
      get '/establishments/est'

      get '/establishments/hotels'
      get '/establishments/restaurants'
      get '/establishments/spas'
      post '/establishments/get_est' #get a particular est with id

      get '/vouchers/all' #all vouchers
      post '/vouchers/est', :to => 'vouchers#show_for_establishment' #for a particular establishment
      get '/establishment_type/all'
      get '/establishment_type/available_types'
      get 'available/cartegories', :to => 'establishment_type#available_types'

      post '/favourites/add', :to => 'profile#add_favourite'
      get 'favourites', :to => 'profile#all' 

      post '/search/vouchers'

      get 'vouchers/hotels', :to => 'establishment_type#hotel_vouchers'
      get 'vouchers/spas', :to => 'establishment_type#spa_vouchers'
      get 'vouchers/restaurants', :to => 'establishment_type#restaurant_vouchers'
      post 'vouchers/category', :to => 'establishment_type#type'

      get 'discover/tags'

      get '/profile/books'
      get '/profile/redeemed_offers'
      post 'profile/rate'


      post '/pay/mobile'
      post '/pay/from_mpesa'
      get '/pay/from_mpesa'
      post '/pay/check_status'

      post 'redeem/voucher'

      get '/pay/check_book_assingment'

      post '/check', :to => 'social_login#check'

      resources :sms, only: [:create]
      mount_devise_token_auth_for 'User', at: 'auth'
      # resources :users

      jsonapi_resources :vouchers 
    end
  end

end
