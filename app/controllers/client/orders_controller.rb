class Client::OrdersController < ApplicationController
  layout 'client'

  def index
    @orders = current_client_user.orders.page(params[:page]).per(10)
  end
end
