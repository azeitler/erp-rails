module InboundWebhooks
  class PipedriveController < ApplicationController
    before_action :verify_event

    def create
      # Save webhook to database
      record = InboundWebhook.create(body: payload,
        controller_name: self.class.name,
        action_name: action_name,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        headers: filtered_headers
      )

      # Queue webhook for processing
      InboundWebhooks::PipedriveJob.perform_later(record)

      # Tell service we received the webhook successfully
      head :ok
    end

    private

    def verify_event
      # needs to have X-Convoy-Source-Id and X-Convoy-Signature headers
      head :bad_request unless request.headers['X-Convoy-Source-Id'] && request.headers['X-Convoy-Signature']
    end
  end
end
