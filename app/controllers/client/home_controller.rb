class Client::HomeController < ApplicationController
  layout 'client'

  def dashboard
    @banners = Banner.active.where("online_at <= ? AND offline_at > ?", Time.current, Time.current)
    @news_tickers = NewsTicker.active.limit(5)
    @winners = Winner.shared.order(created_at: :desc).limit(5)
    @categories = Category.order(:name)
    @items = Item.starting.active.limit(8).order(name: :asc)
  end
end
