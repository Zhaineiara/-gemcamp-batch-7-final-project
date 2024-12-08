class Client::ProfileController < ApplicationController
  before_action :authenticate_client_user!
  layout 'client'

  def profile
    @orders = current_client_user.orders
  end
end
