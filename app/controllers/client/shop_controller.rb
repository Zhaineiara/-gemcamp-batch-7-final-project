class Client::ShopController < ApplicationController
  before_action :set_offer, only: :show
  layout 'client'

  def index
    @offers = Offer.active.order(:name).page(params[:page]).per(10)
    @banners = Banner.active.order(sort: :asc).limit(5)
    @news_tickers = NewsTicker.active.order(sort: :asc).limit(5)
  end

  def show;end

  def create
    offer = Offer.find(params[:offer_id])
    order = Order.new(
      user_id: current_client_user.id,
      offer_id: offer.id,
      genre: 0,
      amount: offer.amount,
      coin: offer.coin
    )

    if order.save
      flash[:notice] = "Order created successfully!"
      redirect_to client_shop_path(offer)
    else
      flash[:alert] = order.errors.full_messages.to_sentence
      redirect_to client_shop_path(offer)
    end
  end


  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end

