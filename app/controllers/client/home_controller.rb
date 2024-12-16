class Client::HomeController < ApplicationController
  layout 'client'

  def index
    @banners = Banner.active.order(sort: :asc).limit(5)
    @news_tickers = NewsTicker.active.order(sort: :asc).limit(5)
    @winners = Winner.published.order(created_at: :desc).limit(5)
    @categories = Category.order(:name)
    @items = Item.starting.active.limit(8).order(created_at: :desc)

    if client_user_signed_in?
      @user_coins = current_client_user.coins
    end
  end
end
