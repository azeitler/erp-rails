module InboundWebhooks
  class BreakcoldJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      event = inbound_webhook.params['event']

      Rails.configuration.event_store.publish(
        BreakcoldEvent.new(data: {
          event: event,
        }),
        stream_name: 'breakcold'
      )

      inbound_webhook.processed!

      # Or mark as failed and re-enqueue the job
      # inbound_webhook.failed!
    end
  end
end
