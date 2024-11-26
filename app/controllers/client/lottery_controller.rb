class Client::LotteryController < ApplicationController
  before_action :set_item, only: :show
  layout 'client'
  def index
    @categories = Category.order(:name)

    if params[:category_id].present?
      @items = Item.includes(:categories)
                   .where(status: 'active', state: 'starting')
                   .where(categories: { id: params[:category_id] })
                   .order(:name)
    else
      @items = Item.includes(:categories)
                   .where(status: 'active', state: 'starting')
                   .order(:name)
    end
  end

  def create
    number_of_tickets = params[:item][:minimum_tickets].to_i
    item = Item.find(params[:item_id])

    total_tickets = item.tickets.count
    minimum_tickets = item.minimum_tickets || 1

    if total_tickets >= minimum_tickets
      flash[:error] = "The minimum number of tickets has already been reached."
      redirect_to client_lottery_path(item) and return
    end

    if (total_tickets + number_of_tickets) > minimum_tickets
      remaining_tickets = minimum_tickets - total_tickets
      flash[:error] = "The number of tickets you want to buy exceeds the minimum allowed. Only #{remaining_tickets} ticket(s) are available."
      redirect_to client_lottery_path(item) and return
    end

    created_tickets = []

    if item.quantity > 0
      number_of_tickets.times do
        ticket = Ticket.new(item_id: item.id, user_id: current_client_user.id, batch_count: item.batch_count)
        if ticket.save
          created_tickets << ticket
        else
          puts Rails.logger.debug ticket.errors.full_messages
        end
      end

      flash[:success] = "Tickets created successfully!"
      redirect_to client_lottery_path(item, ticket_serials: created_tickets.map(&:id))
    else
      flash[:error] = "Item is out of stock."
      redirect_to client_lottery_index_path
    end
  end

  def show
    @item = Item.find(params[:id])
    @tickets = @item.tickets.where(state: 'pending') || []
    total_tickets = @tickets.count
    minimum_tickets = @item.minimum_tickets || 1
    progress = (total_tickets.to_f / minimum_tickets) * 100
    @progress = [progress, 100].min
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
