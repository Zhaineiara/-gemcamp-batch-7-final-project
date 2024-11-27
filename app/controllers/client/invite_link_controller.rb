class Client::InviteLinkController < ApplicationController
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
  end

  private

  def invitation_link
    "http://client.com:3000/client/users/sign_up?promoter=#{current_client_user}"
  end
end


