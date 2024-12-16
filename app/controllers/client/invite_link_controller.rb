class Client::InviteLinkController < ApplicationController
  before_action :authenticate_client_user!
  layout 'client'

  require "rqrcode"
  def index
    @qrcode = RQRCode::QRCode.new(invitation_link)

    # NOTE: showing with default options specified explicitly
    @qrcode_svg = @qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 8,
      standalone: true,
      use_path: true
    )

    if client_user_signed_in?
      @user_coins = current_client_user.coins
      @won_count = current_client_user.winners.won.count
    end
  end

  private

  def invitation_link
    "http://client.com:3000/client/users/sign_up?promoter=#{current_client_user}"
  end
end


