class Client::OrdersController < ApplicationController
  layout 'client'

  def index
    @orders = current_client_user.orders.page(params[:page]).per(10)
  end

  def cancel
    @order = Order.find(params[:id])
    if @order&.may_cancel?
      @order.cancel!
      redirect_to client_orders_path, notice: 'Order has been cancelled.'
    else
      redirect_to client_orders_path, alert: 'Unable to cancel the order.'
    end
  end
end
