class Client::LotteriesController < ApplicationController
  layout 'client'

  def index
    @tickets = current_client_user.tickets.order(created_at: :desc).page(params[:page]).per(10)
  end
end
