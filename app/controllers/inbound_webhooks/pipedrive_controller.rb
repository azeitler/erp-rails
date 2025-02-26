module InboundWebhooks
  class PipedriveController < ApplicationController
    before_action :verify_event

    def create
      # Save webhook to database
      record = InboundWebhook.create(body: payload)

      # Queue webhook for processing
      InboundWebhooks::PipedriveJob.perform_later(record)

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
