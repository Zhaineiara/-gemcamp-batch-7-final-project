class Client::UserAddressesController < ApplicationController
  before_action :set_user

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

  private

  def set_user
    @user = current_client_user
  end

  def user_address_params
    params.require(:user_address).permit(:genre, :name, :street_address, :phone_number, :remark, :is_default, :region_id, :province_id, :city_id, :barangay_id)
  end
end
