class Client::WinningsController < ApplicationController
  layout 'client'

  def index
    @tickets = current_client_user.tickets.where(state: 'won').page(params[:page]).per(10)
  end
end
