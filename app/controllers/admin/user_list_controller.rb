class Admin::UserListController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!

  def index
    @users = User.where(role: 0).includes(:children).page(params[:page]).per(10)
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
      state: 'pending',
      amount: params[:order][:amount],
      coin: params[:order][:coin]
    )

    if order.save
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
      state: 'pending',
      amount: params[:order][:amount],
      coin: params[:order][:coin]
    )

    if order.save
      flash[:notice] = 'Deduct order created successfully!'
      redirect_to admin_user_list_path(@user)
    else
      flash[:alert] = order.errors.full_messages.to_sentence
      render :show
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
