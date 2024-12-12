class Admin::OffersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  def index
    @offers = Offer.order(created_at: :desc).page(params[:page]).per(5)

    if params[:status].present?
      @offers = @offers.where(status: params[:status]).order(created_at: :desc).page(params[:page]).per(5)
    end
  end

  def new
    @offer = Offer.new
  end

  def show
    @offer
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers_path, notice: 'Offer was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      redirect_to admin_offers_path, notice: 'Offer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to admin_offers_path, notice: 'Offer was successfully deleted.'
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :status, :amount, :coin)
  end
end
