class Client::OrdersController < ApplicationController
  layout 'client'

  def index
    @orders = current_client_user.orders.page(params[:page]).per(10)
  end

  def cancel
    @order = Order.find(params[:id])

    if @order&.may_cancel? && sufficient_balance?(@order)
      @order.cancel!
      redirect_to client_orders_path, notice: 'Order has been cancelled.'
    else
      redirect_to client_orders_path, alert: 'Unable to cancel the order due to insufficient coin balance or deposit balance'
    end
  end

  private

  def sufficient_balance?(order)
    user = order.user
    if user.coins < order.coin
      return false
    end
    if user.total_deposit < order.amount
      return false
    end
    true
  end

end
