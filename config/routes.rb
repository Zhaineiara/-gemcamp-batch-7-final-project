Rails.application.routes.draw do
  get 'client/home',  to: 'client/home#dashboard'
  get 'admin/home/',  to: 'admin/home#dashboard'

  namespace :admin do
    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
  end

  namespace :client do
    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
  end

end
