class Admin::BannerController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to admin_banner_index_path, notice: 'News banner was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      redirect_to admin_banner_index_path, notice: 'Banner was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      redirect_to admin_banner_index_path, notice: 'Banner was successfully destroyed.'
    else
      redirect_to admin_banner_index_path, notice: 'Banner could not be destroyed.'
    end
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status)
  end
end
