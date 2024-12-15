class Client::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(resource_or_scope)
    new_client_user_session_path
  end

  def create
    user = User.find_by(email: params[:client_user][:email])
    if user.nil? || user.encrypted_password.blank?
      flash[:alert] = "Email or password can't be blank."
      redirect_to new_client_user_session_path and return
    end

    if user && user.role == 'admin'
      flash[:alert] = "You are not authorized to access the client panel."
      redirect_to new_client_user_session_path and return
    end

    if user&.valid_password?(params[:client_user][:password])
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, user)
      redirect_to client_home_index_path and return
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_client_user_session_path and return
    end
  end
end