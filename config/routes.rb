Rails.application.routes.draw do

  root 'adverts#index'

  resources :adverts do
    patch :publicate, on: :member
    patch :archivate, on: :member
    patch :accept, on: :member
    patch :reject, on: :member
    patch :reject_reason, on: :member
    patch :remove_image, on: :collection
    get :search, on: :collection
  end

  resources :categories, only: [:new, :create, :destroy]

  devise_for :users, controllers: { registrations: 'registrations',
                                    omniauth_callbacks: 'omniauth_callbacks' }

  get '/users/:id/finish_signup' => 'users#finish_signup',
      via: [:get, :patch], :as => :finish_signup

  resources :users do
    patch :show, on: :member
  end

  controller :admin_panel do
    get 'index', as: 'admin_panel_index'
  end

  controller :persons do
    get 'profile', as: 'persons_profile'
  end
end
