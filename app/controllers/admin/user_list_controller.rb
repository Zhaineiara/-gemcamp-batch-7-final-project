class Admin::UserListController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  require 'csv'

  def index
    @users = User.client.includes(:children).order(created_at: :desc).page(params[:page]).per(10)
    @total_used_coins = @users.map { |user| [user.id, Ticket.where(user_id: user.id).sum(:coins)] }.to_h

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          # Add header row
          csv << [
            User.human_attribute_name(:id),
            User.human_attribute_name(:firstname),
            User.human_attribute_name(:lastname),
            User.human_attribute_name(:email),
            User.human_attribute_name(:phone),
            'Parent Email',
            'Total Deposit',
            'Member Total Deposits',
            User.human_attribute_name(:coins),
            'Children Members'
          ]

          # Add user rows
          @users.each do |user|
            csv << [
              user.id,
              user.firstname,
              user.lastname,
              user.email,
              user.phone,
              user.parent&.email || 'N/A',
              user.total_deposit,
              user.children.present? ? user.children.sum { |child| child.total_deposit || 0 } : 0,
              user.coins,
              user.children_members || 0
            ]
          end
        end
        send_data csv_string, filename: "user_list_#{Date.today}.csv"
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def create_increase
    @user = User.find(params[:id])
    order = Order.new(
      user_id: @user.id,
      genre: 'increase',
      remarks: params[:order][:remarks].to_sym,
      amount: params[:order][:amount],
      coin: params[:order][:coin]
    )

    if order.save
      order.pay!
      flash[:notice] = 'Increase order created successfully!'
      redirect_to admin_user_list_path(@user)
    else
      flash[:alert] = order.errors.full_messages.to_sentence
      render :show
    end
  end

  def create_deduct
    Rails.logger.debug("Submitted params: #{params[:order].inspect}")
    @order = Order.new(order_params)
    if @order.save
    else
      Rails.logger.debug("Order errors: #{@order.errors.full_messages}")
    end

    @user = User.find(params[:id])
    order = Order.new(
      user_id: @user.id,
      genre: 'deduct',
      remarks: params[:order][:remarks].to_sym,
      amount: params[:order][:amount],
      coin: params[:order][:coin]
    )

    if order.user.coins >= order.coin
      if order.may_pay?
        order.pay!
        order.save
        redirect_to admin_user_list_path, notice: 'Deduct order created successfully!'
      else
        flash[:alert] = order.errors.full_messages.to_sentence
        redirect_to admin_orders_path, alert: 'Unable to mark the order as deduct.'
      end
    else
      if order.may_cancel?
        order.cancel!
        order.save
        redirect_to admin_user_list_path, alert: 'Insufficient coins to proceed deduction. Order cancelled.'
      end
    end
  end

  private

  def user_params
    params.require(:users).permit(:email, :username, :role, :phone, :coins, :total_deposit, :children_members)
  end

  def order_params
    params.require(:order).permit(:coin, :genre, :remarks)
  end
end
