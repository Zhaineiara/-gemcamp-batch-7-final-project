class Admin::TicketController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  def index
    @tickets = Ticket.includes(:item, :user).order(created_at: :asc)

    @tickets = @tickets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @tickets = @tickets.joins(:item).where('items.name LIKE ?', "%#{params[:item_name]}%") if params[:item_name].present?
    @tickets = @tickets.joins(:user).where('users.email LIKE ?', "%#{params[:email]}%") if params[:email].present?
    @tickets = @tickets.where(state: params[:state]) if params[:state].present?

    if params[:start_date].present? || params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      @tickets = @tickets.where('created_at >= ?', start_date.beginning_of_day) if start_date
      @tickets = @tickets.where('created_at <= ?', end_date.end_of_day) if end_date
    end
  end
end
