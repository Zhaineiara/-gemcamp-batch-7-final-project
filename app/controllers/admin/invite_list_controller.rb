class Admin::InviteListController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  require 'csv'

  def index
    @users = User.includes(:parent)
                 .where.not(parent_id: nil)
                 .order(created_at: :desc)
                 .page(params[:page]).per(10)

    if params[:parent_email].present?
      @users = @users.where("parents.email LIKE ?", "%#{params[:parent_email]}%").page(params[:page]).per(10)
    end

    @total_used_coins = @users.map { |user| [user.id, Ticket.where(user_id: user.id).sum(:coins)] }.to_h

    respond_to do |format|
      format.html
      format.csv do
        csv_string = CSV.generate(headers: true) do |csv|
          csv << [
            'Parent Email',
            'User Email',
            'Total Deposit',
            'Member Total Deposit',
            'Coins',
            'Created At',
            'Used Coins Count',
            'Child Members'
          ]

          @users.each do |user|
            csv << [
              user.parent_email,
              user.email,
              user.total_deposit || 0,
              user.children.sum(:total_deposit),
              user.coins || 0,
              user.created_at.strftime("%Y-%m-%d"),
              @total_used_coins[user.id] || 0,
              user.children_members || 0
            ]
          end
        end

        send_data csv_string, filename: "invite_list_#{Date.today}.csv"
      end
    end
  end
end
