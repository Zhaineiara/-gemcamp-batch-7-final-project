class Client::ProfileController < ApplicationController
  layout 'client'

  def profile
    @orders = current_client_user.orders
  end
end
