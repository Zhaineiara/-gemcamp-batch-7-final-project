class Client::InvitesController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def index
    @users = User.where(parent_id: current_client_user.id).order(created_at: :desc).page(params[:page]).per(10)
    if client_user_signed_in?
      @user_coins = current_client_user.coins
    end
  end
end
