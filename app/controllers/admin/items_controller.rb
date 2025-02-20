class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  require 'csv'

  def index
    @items = Item.includes(:categories).order(created_at: :desc).page(params[:page]).per(5)

    respond_to do |format|
      format.html # For the HTML view
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          # Add header row
          csv << [
            'Name', 'Image', 'Quantity', 'Minimum Tickets', 'State',
            'Batch Count', 'Online At', 'Offline At', 'Start At',
            'Status', 'Categories'
          ]

          # Add data rows
          @items.each do |item|
            csv << [
              item.name,
              item.item_image.url,
              item.quantity,
              item.minimum_tickets,
              item.state,
              item.batch_count,
              item.online_at,
              item.offline_at,
              item.start_at,
              item.status,
              item.categories.pluck(:name).join(', ')
            ]
          end
        end
        send_data csv_string, filename: "items_list_#{Date.today}.csv"
      end
      end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = 'Item created successfully.'
      redirect_to admin_items_path
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit;end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully.'
      redirect_to admin_items_path
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def show;end

  def destroy
    if @item.destroy
      flash[:notice] = 'Item deleted successfully.'
      redirect_to admin_items_path
    else
      flash[:alert] = @item.errors.full_messages.to_sentence
      redirect_to admin_items_path
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
      flash[:notice] = 'Item successfully paused.'
      redirect_to admin_items_path
    else
      redirect_to admin_items_path, alert: @item.nil? ? 'Item not found.' : 'Cannot pause this item.'
    end
  end

  def end
    @item = Item.find_by(id: params[:id])
    @tickets = @item.tickets.pending
    current_batch_tickets = @tickets.where(batch_count: @item.batch_count)
    total_tickets = current_batch_tickets.count
    minimum_tickets = @item.minimum_tickets || 1

    if total_tickets < minimum_tickets
      redirect_to admin_items_path, alert: 'Cannot end this item. The minimum number of tickets in an item must be reach.'
    elsif @item&.may_end?
      @item.end!
      flash[:notice] = 'Item successfully ended.'
      redirect_to admin_items_path
    else
      redirect_to admin_items_path, alert: @item.nil? ? 'Item not found.' : 'Cannot end this item.'
    end
  end

  def cancel
    @item = Item.find_by(id: params[:id])
    if @item&.may_cancel?
      @item.cancel!
      flash[:notice] = 'Item successfully cancelled.'
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
