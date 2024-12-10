class Client::ShopController < ApplicationController
  before_action :set_offer, only: :show
  layout 'client'

  def index
    @offers = Offer.where(status: 'active').order(:name).page(params[:page]).per(10)
    @banners = Banner.active.where("online_at <= ? AND offline_at > ?", Time.current, Time.current)
    @news_tickers = NewsTicker.active.limit(5)
  end

  def show;end

  def create
    offer = Offer.find(params[:offer_id])
    order = Order.new(
      user_id: current_client_user.id,
      offer_id: offer.id,
      genre: 0,
      remarks: params[:remarks],
      state: 'pending',
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

