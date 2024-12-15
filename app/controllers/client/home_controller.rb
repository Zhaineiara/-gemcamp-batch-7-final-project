class Client::HomeController < ApplicationController
  layout 'client'

  def index
    @banners = Banner.active.where("online_at <= ? AND offline_at > ?", Time.current, Time.current)
                     .order(Arel.sql("CASE WHEN sort = 0 THEN 1 ELSE 0 END, sort ASC"))
                     .limit(5)
    @news_tickers = NewsTicker.order(status: :desc)
                              .order(Arel.sql("CASE WHEN sort = 0 THEN 1 ELSE 0 END, sort ASC"))
                              .active.limit(5)
    @winners = Winner.published.order(created_at: :desc).limit(5)
    @categories = Category.order(:name)
    @items = Item.starting.active.limit(8).order(created_at: :desc)
  end
end
