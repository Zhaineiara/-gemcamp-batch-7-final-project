class Client::UserAddressesController < ApplicationController
  before_action :set_user
  before_action :set_user_address, only: [:edit, :update, :destroy]

  def index
    @user_addresses = @user.user_addresses
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

  def edit; end

  def update
    if @user_address.update(user_address_params)
      redirect_to client_user_addresses_path, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user_address.destroy
    redirect_to client_user_addresses_path, notice: 'Address was successfully deleted.'
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