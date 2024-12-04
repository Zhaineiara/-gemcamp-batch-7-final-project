class Client::InvitesController < ApplicationController
  layout 'client'

  def index
    @users = User.where(parent_id: current_client_user.id)
  end
end
