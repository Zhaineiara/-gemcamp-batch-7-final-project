class Admin::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(resource_or_scope)
    new_admin_user_session_path
  end

  def create
    user = User.find_by(email: params[:admin_user][:email])
    if user.nil? || user.encrypted_password.blank?
      flash[:alert] = "Email or password can't be blank."
      redirect_to new_admin_user_session_path and return
    end

    if user && user.role == 'client'
      flash[:alert] = "You are not authorized to access the admin panel."
      redirect_to new_admin_user_session_path and return
    end

    if user&.valid_password?(params[:admin_user][:password])
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, user)
      redirect_to admin_home_path and return
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_admin_user_session_path and return
    end
  end
end