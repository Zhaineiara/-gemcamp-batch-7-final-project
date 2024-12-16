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

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = 'Offer was successfully created.'
      redirect_to admin_offers_path
    else
      flash[:alert] = @offer.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'Offer was successfully updated.'
      redirect_to admin_offers_path
    else
      flash[:alert] = @offer.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def show;end

  def destroy
    if @offer.destroy
      flash[:notice] = 'Offer was successfully destroyed.'
      redirect_to admin_offers_path
    else
      flash[:alert] = @offer.errors.full_messages.to_sentence
      redirect_to admin_offers_path
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :status, :amount, :coin)
  end
end
