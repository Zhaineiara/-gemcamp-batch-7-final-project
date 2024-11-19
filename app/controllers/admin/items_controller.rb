class Admin::ItemsController < ApplicationController
  layout 'admin'

  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path, notice: 'Item created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path, notice: 'Item updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to admin_items_path, notice: 'Item deleted successfully.'
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_image, :name, :quantity, :minimum_tickets, :state, :batch_count, :online_at, :offline_at, :start_at, :status)
  end
end
