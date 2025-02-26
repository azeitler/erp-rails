class WebhookClient < ApplicationClient
  BASE_URI = ""

  attr_reader :webhook_url

  def initialize(webhook_url:)
    @webhook_url = webhook_url
  end

  def post_message(**kwargs)
    post(webhook_url, body: kwargs)
  end
end
