class Admin::UserListController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!

  def index
    @users = User.where(role: 0).includes(:children).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def category_params
    params.require(:users).permit(:email, :username, :role, :phone, :coins, :total_deposit, :children_members)
  end
end
