class Client::WinningsController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def index
    @winners = current_client_user.winners.order(created_at: :desc).page(params[:page]).per(10)
    if client_user_signed_in?
      @user_coins = current_client_user.coins
      @won_count = current_client_user.winners.won.count
    end
  end
end
