class Client::LotteriesController < ApplicationController
  layout 'client'
  before_action :authenticate_client_user!

  def index
    @tickets = current_client_user.tickets.order(created_at: :desc).page(params[:page]).per(10)
  end
end
