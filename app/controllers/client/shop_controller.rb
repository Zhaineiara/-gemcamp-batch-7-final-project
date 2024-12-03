class Client::ShopController < ApplicationController
  layout 'client'

  def index
    @offers = Offer.where(status: 'active').order(:name)
  end

  def show
    @offer = Offer.find(params[:id])
  end
end

