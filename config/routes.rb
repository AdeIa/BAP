Rails.application.routes.draw do
  
  root to: "home#index"
  
  # home
  get 'home/index'

  # settings
  get 'settings' => 'settings#index'

  resources :settings, only: [:index] do
    collection do
      put 'update_multiple'
    end
  end

  # contact
  get 'contact' => 'contacts#index'

  # books
  get 'books' => 'books#index'
  get 'books/download' => 'books#download'
  get 'books/save_into_database' => 'books#save_into_database'
  get 'books/search' 
  match 'books/detail/:id', :to => 'books#detail', :as => :books_detail, :via => :get
  match 'books/add_registration_number/:id', :to => 'books#add_registration_number', :as => :books_add_registration_number, :via => :get
  match 'books/destroy/:id', :to => 'books#destroy', :as => :books_destroy, :via => :delete
  
  resources :books, only: [:index]
  resources :books, only: [:index] do
    collection do
      post 'edit_multiple'
      put 'update_multiple'
    end
  end

  # loans
  get 'loans/history'
  match 'loans/user/:id', :to => 'loans#user', :as => :loans_user, :via => :get
  match 'loans/prolong/:id', :to => 'loans#prolong', :as => :loans_prolong, :via => :get
  match 'loans/return_book/:id', :to => 'loans#return_book', :as => :loans_return_book, :via => :get
  match 'loans/user_history/:id', :to => 'loans#user_history', :as => :loans_user_history, :via => :get
  match 'loans/user_all/:id', :to => 'loans#user_all', :as => :loans_user_all, :via => :get
  resources :loans

  # reservations
  match 'reservations/user/:id', :to => 'reservations#user', :as => :reservations_user, :via => :get
  resources :reservations

  # admin
  get 'admins/users/approved'
  get 'admins/users'  => 'admins/users#index'
  match 'admins/users/:id', :to => 'admins/users#destroy', :as => :admin_destroy_user, :via => :delete
  devise_for :admins, :controllers => { registrations: 'admins/registrations', sessions: 'admins/sessions', passwords: 'admins/passwords', confirmations: 'admins/confirmations'  }
  namespace :admins do
    resources :users
  end

  # user
  match 'user/self_destroy/:id', :to => 'admins/users#self_destroy', :as => :user_self_destroy_user, :via => :delete
  devise_for :users, :controllers => { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords', confirmations: 'users/confirmations'  }
  
end
