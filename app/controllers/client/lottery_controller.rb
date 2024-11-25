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
    number_of_create = params[:minimum_tickets].to_i
    item = Item.find(params[:item_id])
    puts item
    if item.quantity > 0
      number_of_create.times do
        ticket = Ticket.new(item_id: item.id, user_id: current_client_user, batch_count: item.batch_count)

        if ticket.save
          redirect_to client_lottery_index_path
        end
      end
    end
  end

  def show
    @item
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
