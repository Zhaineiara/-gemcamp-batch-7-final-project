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
      get 'user_list/index'
      devise_for :users, controllers: {
        registrations: 'admin/registrations',
        sessions: 'admin/sessions'
      }
    end
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      get 'profile/profile'
      get 'invite_link/index'
      resources :user_addresses, only: [:index, :new, :create, :edit, :update, :destroy]

      devise_for :users, controllers: {
        registrations: 'client/registrations',
        sessions: 'client/sessions'
      }
    end
  end

  root to: 'welcome#index'

end