Rails.application.routes.draw do
  get 'client/home',  to: 'client/home#dashboard'
  get 'admin/home/',  to: 'admin/home#dashboard'

  namespace :admin do
    devise_for :users, controllers: {
      registrations: 'admin/registrations',
      sessions: 'admin/sessions'
    }
  end

  namespace :client do
    devise_for :users, controllers: {
      registrations: 'client/registrations',
      sessions: 'client/sessions'
    }
  end

end
