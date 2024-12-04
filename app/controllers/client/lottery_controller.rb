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
                   .page(params[:page]).per(10)
    else
      @items = Item.includes(:categories)
                   .where(status: 'active', state: 'starting')
                   .order(:name)
                   .page(params[:page]).per(10)
    end
  end

  def create
    number_of_tickets = params[:item][:minimum_tickets].to_i
    item = Item.find(params[:item_id])

    if current_client_user.coins < number_of_tickets
      flash[:error] = "Insufficient coins. You need #{number_of_tickets - current_client_user.coins} more coin(s) to complete this purchase."
      redirect_to client_lottery_path(item) and return
    end

    number_of_tickets.times do
      ticket = Ticket.new(item_id: item.id, user_id: current_client_user.id, batch_count: item.batch_count)
      if ticket.save
        flash[:notice] = "#{number_of_tickets} Tickets created successfully!"
      else
        flash[:alert] = ticket.errors.full_messages.to_sentence
      end
    end
    redirect_to client_lottery_path(item)
  end

  def show
    @item = Item.find(params[:id])
    @tickets = @item.tickets.pending
    current_batch_tickets = @tickets.where(batch_count: @item.batch_count)

    total_tickets = current_batch_tickets.count
    minimum_tickets = @item.minimum_tickets || 1
    progress = (total_tickets.to_f / minimum_tickets) * 100
    @progress = [progress, 100].min
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
