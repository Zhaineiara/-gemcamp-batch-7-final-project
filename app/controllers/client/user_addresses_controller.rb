class Client::UserAddressesController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  before_action :set_user
  before_action :set_user_address, only: [:edit, :update, :destroy]

  def index
    @user_addresses = @user.user_addresses.includes(:region, :province, :city, :barangay)
    if client_user_signed_in?
      @user_coins = current_client_user.coins
    end
  end

  def new
    @user_address = @user.user_addresses.new
  end

  def create
    @user_address = @user.user_addresses.new(user_address_params)

    if @user_address.save
      redirect_to client_user_addresses_path, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def edit
    if client_user_signed_in?
      @user_coins = current_client_user.coins
    end
    @address = @user.user_addresses.find(params[:id])

    if @address.nil?
      redirect_to client_user_addresses_path, alert: 'Address not found.'
    end
  end

  def update
    if @user_address.update(user_address_params)
      if @user_address.is_default
        @user.user_addresses.where.not(id: @user_address.id).update_all(is_default: false)
      end
      redirect_to client_user_addresses_path, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user.user_addresses.count == 1
      flash[:alert] = "You cannot delete the default address."
    else
      @user_address.destroy
      flash[:notice] = 'Address was successfully deleted.'
    end

    redirect_to client_user_addresses_path
  end

  private

  def set_user
    @user = current_client_user
  end

  def set_user_address
    @user_address = @user.user_addresses.find(params[:id])
  end

  def user_address_params
    params.require(:user_address).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :region_id, :province_id, :city_id, :barangay_id)
  end
end