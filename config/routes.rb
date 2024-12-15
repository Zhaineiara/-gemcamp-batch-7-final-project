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

  constraints(AdminDomainConstraint.new) do
    namespace :admin do
      resources :banner, except: :show
      resources :categories, except: :show
      resources :home, only: [:index]
      resources :invite_list, only: [:index]
      resources :news_tickers, except: :show
      resources :offers
      resources :ticket, only: [:index]

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

      resources :user_list, only: [:index, :show] do
        member do
          post 'increase', to: 'user_list#create_increase', as: :create_increase
          post 'deduct', to: 'user_list#create_deduct', as: :create_deduct
          post 'bonus', to: 'user_list#create_bonus', as: :create_bonus
        end
      end

      resources :winners, only: [:index, :show] do
        member do
          put :claim
          put :submit
          put :pay
          put :ship
          put :deliver
          put :share
          put :publish
          put :remove_publish
        end
      end

      devise_for :users, controllers: {
        registrations: 'admin/registrations',
        sessions: 'admin/sessions'
      }
    end
    root 'admin/home#index', as: :admin_root
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      resources :claims, only: [:new, :create, :edit, :update]
      resources :home, only: [:index]
      resources :invite_link, only: [:index]
      resources :invites, only: [:index]
      resources :lotteries, only: [:index]
      resources :lottery
      resources :profile, only: [:index]
      resources :share, only: [:edit, :update, :index]
      resources :shop
      resources :user_addresses, except: :show
      resources :winnings, only: [:index]

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