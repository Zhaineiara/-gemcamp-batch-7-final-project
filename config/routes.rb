Rails.application.routes.draw do
  get 'client/home', to: 'client/home#dashboard'
  get 'admin/home/', to: 'admin/home#dashboard'

  constraints(AdminDomainConstraint.new) do
    namespace :admin do
      devise_for :users, controllers: {
        registrations: 'admin/registrations',
        sessions: 'admin/sessions'
      }
    end
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      get 'profile/profile'
      resources :user_addresses, only: [:index, :new, :create, :edit, :update, :destroy]

      devise_for :users, controllers: {
        registrations: 'client/registrations',
        sessions: 'client/sessions'
      }
    end
  end

  root to: 'welcome#index'

end