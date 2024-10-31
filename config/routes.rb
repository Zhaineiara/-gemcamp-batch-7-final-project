Rails.application.routes.draw do
  get 'client/home',  to: 'client/home#dashboard'
  get 'admin/home/',  to: 'admin/home#dashboard'
  devise_for :users
end
