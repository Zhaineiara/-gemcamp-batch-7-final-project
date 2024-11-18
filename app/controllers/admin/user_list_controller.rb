class Admin::UserListController < ApplicationController
  layout 'admin'

  def index
    @users = User.where(role: 'client')
  end
end
