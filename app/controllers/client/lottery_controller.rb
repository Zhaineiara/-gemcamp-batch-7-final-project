class Client::LotteryController < ApplicationController
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
end
