class Client::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    client_home_path
  end

  def after_update_path_for(resource)
    client_profile_profile_path
  end
end
