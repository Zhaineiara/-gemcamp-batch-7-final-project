class Admin::NewsTickersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_news_ticker, only: [:edit, :update, :destroy]
  before_action :set_available_sort_values, only: [:new, :edit]

  def index
    @news_tickers = NewsTicker.page(params[:page]).per(10).order(status: :desc)
                              .order(Arel.sql("CASE WHEN sort = 0 THEN 1 ELSE 0 END, sort ASC"))
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin_id = current_admin_user.id
    if @news_ticker.save
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  def destroy
    if @news_ticker.destroy
      redirect_to admin_news_tickers_path, notice: 'News ticker was successfully destroyed.'
    else
      redirect_to admin_news_tickers_path, notice: 'News ticker could not be destroyed.'
    end
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status, :sort)
  end

  def set_available_sort_values
    taken_sort_values = NewsTicker.where.not(sort: nil).pluck(:sort)
    max_sort = NewsTicker.count
    @available_sort_values = (1..max_sort).to_a - taken_sort_values
    @available_sort_values.unshift(["Default", 0])
  end
end
