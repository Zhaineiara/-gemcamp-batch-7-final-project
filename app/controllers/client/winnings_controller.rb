class Client::WinningsController < ApplicationController
  layout 'client'

  def index
    @winners = current_client_user.winners.page(params[:page]).per(10)
  end
end
