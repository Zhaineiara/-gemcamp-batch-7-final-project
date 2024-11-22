class Admin::UserListController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!

  def index
    @users = User.where(role: 'client')
  end
end
