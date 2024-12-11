class Admin::OrderController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_order, only: [:submit, :cancel, :pay]
  require 'csv'

  def index
    @orders = Order.includes(:offer, :user).order(created_at: :asc).page(params[:page]).per(10)

    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.joins(:user).where(users: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer_id: params[:offer_id]) if params[:offer_id].present?

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      @orders = @orders.where(created_at: start_date.beginning_of_day..end_date.end_of_day) if start_date && end_date
    end

    @subtotal_amount = @orders.to_a.sum { |order| order.amount&.to_i || 0 }
    @subtotal_coins = @orders.to_a.sum { |order| order.coin&.to_i || 0 }

    total_orders = Order.all
    @total_amount = total_orders.sum(:amount)
    @total_coins = total_orders.sum(:coin)

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << [
            Order.human_attribute_name(:id),
            'Offer',
            'Customer',
            'Serial Number',
            'State',
            'Amount',
            'Coins',
            'Remark',
            'Genre',
            'Created at',
          ]

          @orders.each do |order|
            csv << [
              order.id,
              order.offer&.name,
              order.user.email,
              order.serial_number,
              order.state,
              order.amount,
              order.coin,
              order.remarks,
              order.genre,
              order.created_at.strftime('%Y-%m-%d %H:%M:%S')
            ]
          end
        end
        send_data csv_string, filename: "order_list_#{Date.today}.csv"
      end
    end
  end

  def submit
    @order = Order.find_by(id: params[:id])
    if @order&.may_submit?
      @order.submit!
      @order.save
      redirect_to admin_order_index_path, notice: 'Order has been submitted.'
    else
      redirect_to admin_order_index_path, alert: 'Unable to submit the order.'
    end
  end

  def cancel
    @order = Order.find_by(id: params[:id])
    if @order&.may_cancel?
      if @order.cancel
        @order.save
        redirect_to admin_order_index_path, notice: 'Order has been cancelled.'
      else
        redirect_to admin_order_index_path, alert: @order.errors.full_messages.to_sentence
      end
    else
      redirect_to admin_order_index_path, alert: 'Unable to cancel the order.'
    end
  rescue ActiveRecord::Rollback
    redirect_to admin_order_index_path, alert: 'Insufficient coins or deposit to cancel the order.'
  end

  def pay
    @order = Order.find_by(id: params[:id])

    if @order&.genre == 'deduct'
      if @order.user.coins >= @order.coin
        if @order.may_pay?
          @order.pay!
          @order.save
          redirect_to admin_order_index_path, notice: 'Order has been paid.'
        else
          redirect_to admin_order_index_path, alert: 'Unable to mark the order as paid.'
        end
      end
    else
      if @order&.may_pay?
        @order.pay!
        @order.save
        redirect_to admin_order_index_path, notice: 'Order has been paid.'
      else
        redirect_to admin_order_index_path, alert: 'Unable to mark the order as paid.'
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
