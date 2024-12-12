class Admin::WinnersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_order, only: [:claim, :submit, :pay, :ship, :deliver, :share, :publish, :remove_publish]

  def index
    @winners = Winner.order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv do
        headers = [
          "Item ID", "Ticket ID", "User ID", "Address ID", "Item Batch Count",
          "State", "Price", "Paid At", "Admin ID", "Picture", "Comment",
          "Created At", "Updated At"
        ]

        csv_data = CSV.generate(headers: true) do |csv|
          csv << headers
          @winners.each do |winner|
            csv << [
              winner.item_id,
              winner.ticket_id,
              winner.user_id,
              winner.address_id || 'N/A',
              winner.item_batch_count,
              winner.state,
              winner.price,
              winner.paid_at,
              winner.admin_id || 'N/A',
              winner.picture || 'N/A',
              winner.comment || 'N/A',
              winner.created_at,
              winner.updated_at
            ]
          end
        end

        send_data csv_data, filename: "winners-#{Date.today}.csv"
      end
    end
  end

  def show
    @winner = Winner.find(params[:id])
  end

  def claim
    @winners = Winner.find_by(id: params[:id])
    if @winners&.may_claim?
      @winners.claim!
      @winners.save
      redirect_to admin_winners_path, notice: 'Winning ticket has been submitted.'
    else
      redirect_to admin_winners_path, alert: 'Unable to submit the winning ticket.'
    end
  end

  def submit
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_submit?
      @winner.submit!
      redirect_to admin_winners_path, notice: 'Winning ticket has been submitted.'
    else
      redirect_to admin_winners_path, alert: 'Unable to submit the winning ticket.'
    end
  end

  def pay
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_pay?
      @winner.pay!
      redirect_to admin_winners_path, notice: 'Payment has been processed.'
    else
      redirect_to admin_winners_path, alert: 'Unable to process payment.'
    end
  end

  def ship
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_ship?
      @winner.ship!
      redirect_to admin_winners_path, notice: 'Item has been shipped.'
    else
      redirect_to admin_winners_path, alert: 'Unable to ship the item.'
    end
  end

  def deliver
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_deliver?
      @winner.deliver!
      redirect_to admin_winners_path, notice: 'Item has been delivered.'
    else
      redirect_to admin_winners_path, alert: 'Unable to deliver the item.'
    end
  end

  def share
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_share?
      @winner.share!
      redirect_to admin_winners_path, notice: 'Winning moment has been shared.'
    else
      redirect_to admin_winners_path, alert: 'Unable to share the winning moment.'
    end
  end

  def publish
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_publish?
      @winner.publish!
      redirect_to admin_winners_path, notice: 'Winning moment has been published.'
    else
      redirect_to admin_winners_path, alert: 'Unable to publish the winning moment.'
    end
  end

  def remove_publish
    @winner = Winner.find_by(id: params[:id])
    if @winner&.may_remove_publish?
      @winner.remove_publish!
      redirect_to admin_winners_path, notice: 'Winning moment publication has been removed.'
    else
      redirect_to admin_winners_path, alert: 'Unable to remove publication of the winning moment.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end
