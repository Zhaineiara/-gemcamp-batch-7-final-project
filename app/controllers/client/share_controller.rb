class Client::ShareController < ApplicationController
  layout 'client'

  def index
    @winners = Winner.published.order(created_at: :desc).page(params[:page]).per(10)
    @banners = Banner.active.order(sort: :asc).limit(5)
    @news_tickers = NewsTicker.active.order(sort: :asc).limit(5)
  end

  def edit
    @winner = Winner.find(params[:id])
  end

  def update
    @winner = Winner.find(params[:id])

    if @winner.update(winner_params)
      if @winner.may_share?
        @winner.share!

        order = Order.new(
          user_id: @winner.user_id,
          genre: 'share',
          amount: 0,
          coin: 1
        )

        if order.save
          if order.may_pay?
            order.pay!
          end
        end

        redirect_to client_winnings_path, notice: "Your winning has been shared successfully!"
      else
        redirect_to client_winnings_path, alert: "The winning can only be shared if it is in the 'delivered' state."
      end
    else
      flash.now[:alert] = "There was an error updating your winning. Please try again."
      render :edit
    end
  end

  private

  def winner_params
    params.require(:winner).permit(:picture, :comment)
  end
end
