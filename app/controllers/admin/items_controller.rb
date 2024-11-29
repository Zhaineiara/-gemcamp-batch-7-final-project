class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.includes(:categories).order(:name)
  end

  def show
    @item
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

  def edit;end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path, notice: 'Item updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to admin_items_path, notice: 'Item deleted successfully.'
    end
  end

  def start
    @item = Item.find_by(id: params[:id])

    if @item.nil?
      redirect_to admin_items_path, alert: 'Item not found.'
    else
      error_messages = []

      if @item.quantity <= 0
        error_messages << 'Quantity is 0 or less.'
      end

      if Date.today >= @item.offline_at
        error_messages << 'Offline date has passed.'
      end

      if @item.status != 'active'
        error_messages << 'Item status is not active.'
      end

      if @item.may_start?
        @item.start!
        redirect_to admin_items_path, notice: 'Item successfully started.'
      else
        if error_messages.any?
          redirect_to admin_items_path, alert: error_messages.join(' ')
        end
      end
    end
  end

  def pause
    @item = Item.find_by(id: params[:id])
    if @item&.may_pause?
      @item.pause!
      redirect_to admin_items_path
    else
      redirect_to admin_items_path, alert: @item.nil? ? 'Item not found.' : 'Cannot pause this item.'
    end
  end

  def end
    @item = Item.find_by(id: params[:id])
    if @item&.may_end?
      @item.end!
      redirect_to admin_items_path
    else
      redirect_to admin_items_path, alert: @item.nil? ? 'Item not found.' : 'Cannot end this item.'
    end
  end

  def cancel
    @item = Item.find_by(id: params[:id])
    if @item&.may_cancel?
      @item.cancel!
      redirect_to admin_items_path
    else
      redirect_to admin_items_path, alert: @item.nil? ? 'Item not found.' : 'Cannot cancel this item.'
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_image, :name, :quantity, :minimum_tickets, :state, :batch_count, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end
end
