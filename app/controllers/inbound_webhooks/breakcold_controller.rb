module InboundWebhooks
  class BreakcoldController < ApplicationController
    before_action :verify_event

    def create
      # Save webhook to database
      record = InboundWebhook.create(body: payload,
        controller_name: self.class.name,
        action_name: action_name,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        headers: request.headers.to_h
      )

      # Queue webhook for processing
      InboundWebhooks::BreakcoldJob.perform_later(record)

      # Tell service we received the webhook successfully
      head :ok
    end

    private

    def verify_event
      # TODO: Verify the event was sent from the service
      # Render `head :bad_request` if verification fails
    end
  end
end
