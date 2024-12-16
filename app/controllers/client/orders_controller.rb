class Client::OrdersController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def index
    @orders = current_client_user.orders.order(created_at: :desc).page(params[:page]).per(10)
    if client_user_signed_in?
      @user_coins = current_client_user.coins
      @won_count = current_client_user.winners.won.count
    end
  end

  def cancel
    @order = Order.find(params[:id])

    if @order&.may_cancel? && sufficient_balance?(@order)
      if current_client_user && @order.pending?
        redirect_to client_orders_path, notice: "Can't cancel pending order"
      elsif current_client_user && @order.paid?
        redirect_to client_orders_path, notice: "Can't cancel paid order"
      else
        @order.cancel!
        redirect_to client_orders_path, notice: 'Order has been cancelled.'
      end
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
