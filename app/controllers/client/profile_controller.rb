class Client::ProfileController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def index
    @orders = current_client_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end
end
