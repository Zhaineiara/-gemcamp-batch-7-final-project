class Client::ClaimsController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def new
    @winner = Winner.find(params[:winner_id])
    @user_address = current_client_user.user_addresses.build

    if client_user_signed_in?
      @user_coins = current_client_user.coins
      @won_count = current_client_user.winners.won.count
    end
  end
  def create
    Rails.logger.debug "Params: #{params.inspect}"
    @winner = Winner.find(params[:winner_id])
    @user_address = current_client_user.user_addresses.build(user_address_params)
    if @user_address.save
      @winner.claim!
      @winner.save
      @winner.update(address_id: @user_address.id)
      redirect_to client_winnings_path, notice: "Prize claimed successfully!"
    else
      render :new, alert: "There was an error claiming your prize."
    end
  end

  def edit
    @winner = Winner.find(params[:id])
    @user_addresses = current_client_user.user_addresses

    if client_user_signed_in?
      @user_coins = current_client_user.coins
      @won_count = current_client_user.winners.won.count
    end
  end

  def update
    Rails.logger.debug "Params: #{params.inspect}"
    @winner = Winner.find(params[:id])
    @winner.user_address = UserAddress.find(params['winner']['user_address_id'])

    if @winner.save
      @winner.claim!
      redirect_to client_winnings_path, notice: "Prize claimed successfully!"
    else
      render :new, alert: "There was an error claiming your prize."
    end
  end

  private

  def user_address_params
    params.require(:user_address).permit(:name, :street_address, :phone_number, :genre, :region_id, :province_id, :city_id, :barangay_id, :is_default, :remark)
  end
end
