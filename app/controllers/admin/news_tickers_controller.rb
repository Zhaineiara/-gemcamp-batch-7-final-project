class Admin::NewsTickersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_news_ticker, only: [:edit, :update, :destroy]
  before_action :news_ticker_sort_values, only: [:new, :edit]

  def index
    @news_tickers = NewsTicker.order(status: :desc).order(sort: :asc).page(params[:page]).per(10)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin_id = current_admin_user.id
    if @news_ticker.save
      flash[:notice] = 'News ticker was successfully created.'
      redirect_to admin_news_tickers_path
    else
      flash[:alert] = @news_ticker.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      flash[:notice] = 'News ticker was successfully updated.'
      redirect_to admin_news_tickers_path
    else
      flash[:alert] = @news_ticker.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = 'News ticker was successfully destroyed.'
      redirect_to admin_news_tickers_path
    else
      flash[:alert] = @news_ticker.errors.full_messages.to_sentence
      redirect_to admin_news_tickers_path
    end
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status, :sort)
  end

  def news_ticker_sort_values
    news_ticker_sort_values = NewsTicker.where.not(sort: nil).pluck(:sort)
    news_ticker_max_sort = NewsTicker.count
    @news_ticker_sort_values = (1..news_ticker_max_sort).to_a - news_ticker_sort_values
    @news_ticker_sort_values.unshift(["Default", 0])
  end
end
