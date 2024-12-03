class Admin::OrderController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!

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
  end
end
