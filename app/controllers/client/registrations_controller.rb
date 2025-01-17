class Client::RegistrationsController < Devise::RegistrationsController
  layout 'client'
  before_action :store_params, only: [:new]
  def after_sign_up_path_for(resource)
    client_home_index_path
  end
  def after_update_path_for(resource)
    client_profile_index_path
  end

  def new
    @promoter = User.client.find_by(email: cookies[:promoter])
    super
  end

  def create
    super do |user|
      if cookies[:promoter].present?
        promoter = User.client.find_by(email: cookies[:promoter])
        user.update(parent_id: promoter.id)
        cookies.delete(:promoter)
        user.save
      else
        user = User.client.new(sign_up_params)
        user.save
      end
    end
  end

  def edit
    if client_user_signed_in?
      @user_coins = current_client_user.coins
      @won_count = current_client_user.winners.won.count
    end
  end

  private

  def sign_up_params
    params.require(:client_user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :parent_id)
  end

  def account_update_params
    params.require(:client_user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :current_password, :phone,  :avatar)
  end

  def store_params
    if params[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end
end
