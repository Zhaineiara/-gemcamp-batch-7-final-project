class Client::ProfileController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def index
    @orders = current_client_user.orders.order(created_at: :desc).page(params[:page]).per(10)
    if client_user_signed_in?
      @user_coins = current_client_user.coins
    end
  end
end
