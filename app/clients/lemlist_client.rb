# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LemlistClient < ApplicationClient
  BASE_URI = "https://api.lemlist.com/api"

  def api_key
    @api_key ||= Rails.application.credentials.dig(:lemlist, :api_key)
  end


  def team
    get("/team").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load your account"
  end


  def authorization_header
    {
      "Authorization" => "Basic " + Base64.strict_encode64(":#{api_key}")
    }
  end

end
