class Admin::TicketController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  def index
    @tickets = Ticket.includes(:item, :user).order(created_at: :desc).page(params[:page]).per(10)
    @tickets = @tickets.where(serial_number: params[:serial_number]).page(params[:page]).per(10) if params[:serial_number].present?
    @tickets = @tickets.joins(:item).where('items.name LIKE ?', "%#{params[:item_name]}%").page(params[:page]).per(10) if params[:item_name].present?
    @tickets = @tickets.joins(:user).where('users.email LIKE ?', "%#{params[:email]}%").page(params[:page]).per(10) if params[:email].present?
    @tickets = @tickets.where(state: params[:state]).page(params[:page]).per(10) if params[:state].present?

    if params[:start_date].present? || params[:end_date].present?
      @tickets = Ticket.includes(:item, :user).order(created_at: :asc).page(params[:page]).per(10)
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      @tickets = @tickets.where('created_at >= ?', start_date.beginning_of_day).page(params[:page]).per(10) if start_date
      @tickets = @tickets.where('created_at <= ?', end_date.end_of_day).page(params[:page]).per(10) if end_date
    end

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          # Add header row
          csv << [
            Ticket.human_attribute_name(:id),
            'Item Name',
            'User Email',
            'Batch Count',
            'Coin',
            Ticket.human_attribute_name(:serial_number),
            Ticket.human_attribute_name(:state),
            Ticket.human_attribute_name(:created_at)
          ]

          @tickets.each do |ticket|
            csv << [
              ticket.id,
              ticket.item&.name || 'N/A',
              ticket.user&.email || 'N/A',
              ticket.batch_count || 'N/A',
              ticket.coins || 'N/A',
              ticket.serial_number || 'N/A',
              ticket.state || 'N/A',
              ticket.created_at
            ]
          end
        end
        send_data csv_string, filename: "tickets_#{Date.today}.csv"
      end
    end
  end
end
