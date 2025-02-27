module InboundWebhooks
  class PipedriveJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      meta = inbound_webhook.params['meta']
      action = meta['action']
      entity = meta['entity']
      event = "#{entity}.#{action}"

      Rails.configuration.event_store.publish(
        PipedriveEvent.new(data: {
          event: event,
        }),
        stream_name: 'pipedrive'
      )

      inbound_webhook.processed!

      # Or mark as failed and re-enqueue the job
      # inbound_webhook.failed!
    end
  end
end
