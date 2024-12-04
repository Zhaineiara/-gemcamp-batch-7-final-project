class Client::OrdersController < ApplicationController
  layout 'client'

  def index
    @orders = current_client_user.orders
  end
end
