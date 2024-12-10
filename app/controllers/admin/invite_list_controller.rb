class Admin::InviteListController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!

  def index
    @users = User.includes(:parent)
                 .where.not(parent_id: nil)
                 .joins("LEFT JOIN users parents ON users.parent_id = parents.id")
                 .select("users.*, parents.email AS parent_email")
                 .group("users.id, parents.email")
                 .order(:parent_email)
                 .page(params[:page]).per(10)

    if params[:parent_email].present?
      @users = @users.where("parents.email LIKE ?", "%#{params[:parent_email]}%").page(params[:page]).per(10)
    end

    @total_used_coins = @users.map { |user| [user.id, Ticket.where(user_id: user.id).sum(:coins)] }.to_h
  end
end
