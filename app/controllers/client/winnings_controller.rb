class Client::WinningsController < ApplicationController
  layout 'client'

  def index
    @tickets = current_client_user.tickets.where(state: 'won')
  end
end
