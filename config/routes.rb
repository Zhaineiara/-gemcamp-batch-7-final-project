Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :regions, only: %i[index show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: %i[index show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end
      resources :cities, only: %i[index show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end
      resources :barangays, only: %i[index show], defaults: { format: :json }
    end
  end

  get 'client/home', to: 'client/home#dashboard'
  get 'admin/home/', to: 'admin/home#dashboard'

  constraints(AdminDomainConstraint.new) do
    namespace :admin do
      resources :user_list, only: [:index, :show]
      get 'ticket/index'
      get 'order/index'
      resources :items
      resources :categories, except: :show
      resources :offers

      resources :orders, controller: 'order', only: [:index] do
        member do
          put :submit
          put :cancel
          put :pay
        end
      end

      resources :items do
        member do
          put :start
          put :pause
          put :end
          put :cancel
        end
      end

      devise_for :users, controllers: {
        registrations: 'admin/registrations',
        sessions: 'admin/sessions'
      }
    end

    namespace :users, only: [] do
      resources :clients, only: [] do
        member do
          get 'orders/increase/new', to: 'orders#new', as: :new_increase
          post 'orders/increase', to: 'orders#create', as: :create_increase

          get 'orders/deduct/new', to: 'orders#new', as: :new_deduct
          post 'orders/deduct', to: 'orders#create', as: :create_deduct

          get 'orders/bonus/new', to: 'orders#new', as: :new_bonus
          post 'orders/bonus', to: 'orders#create', as: :create_bonus
        end
      end
    end
    root 'admin/home#dashboard', as: :admin_root
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      get 'profile/profile'
      get 'invite_link/index'
      resources :shop
      resources :lottery
      resources :user_addresses, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :orders, only: [:index]
      resources :lotteries, only: [:index]
      resources :invites, only: [:index]
      resources :winnings, only: [:index]
      resources :claims, only: [:new, :create, :edit, :update]
      resources :share, only: [:edit, :update, :index]

      resources :orders, controller: 'orders', only: [:index] do
        member do
          put :cancel
        end
      end

      devise_for :users, controllers: {
        registrations: 'client/registrations',
        sessions: 'client/sessions'
      }
    end
    root 'client/home#dashboard', as: :client_root
  end
end