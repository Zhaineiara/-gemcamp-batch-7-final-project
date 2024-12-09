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
      resources :user_list, only: [:index, :show]do
        member do
          post 'increase', to: 'user_list#create', as: :create_increase
          post 'deduct', to: 'user_list#create', as: :create_deduct
          post 'bonus', to: 'user_list#create', as: :create_bonus
        end
      end

      get 'ticket/index'
      get 'order/index'
      resources :invite_list, only: [:index]
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