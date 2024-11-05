class Client::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    client_home_path
  end

  def after_update_path_for(resource)
    client_profile_profile_path
  end

  private

  def sign_up_params
    params.require(:client_user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :phone)
  end

  def account_update_params
    params.require(:client_user).permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :current_password, :phone,  :avatar)
  end
end
