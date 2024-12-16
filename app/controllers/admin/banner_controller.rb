class Admin::BannerController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_banner, only: [:edit, :update, :destroy]
  before_action :banner_sort_values, only: [:new, :edit]

  def index
    @banners = Banner.order(status: :desc).order(sort: :asc).page(params[:page]).per(10)
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      flash[:notice] = 'Banner was successfully created.'
      redirect_to admin_banner_index_path
    else
      flash[:alert] = @banner.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      flash[:notice] = 'Banner was successfully updated.'
      redirect_to admin_banner_index_path
    else
      flash[:alert] = @banner.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = 'Banner was successfully destroyed.'
      redirect_to admin_banner_index_path
    else
      flash[:alert] = @banner.errors.full_messages.to_sentence
      redirect_to admin_banner_index_path
    end
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status, :sort)
  end

  def banner_sort_values
    banner_sort_values = Banner.where.not(sort: nil).pluck(:sort)
    banner_max_sort = Banner.count
    @banner_sort_values = (1..banner_max_sort).to_a - banner_sort_values
    @banner_sort_values.unshift(["Default", 0])
  end
end
