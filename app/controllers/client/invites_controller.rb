class Client::InvitesController < ApplicationController
  layout 'client'

  def index
    @users = User.where(parent_id: current_client_user.id).order(created_at: :desc).page(params[:page]).per(10)
  end
end
