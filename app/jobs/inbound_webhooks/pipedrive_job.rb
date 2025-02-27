module InboundWebhooks
  class PipedriveJob < ApplicationJob
    queue_as :default

    attr_reader :meta, :action, :event, :entity

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      @meta = inbound_webhook.params['meta']
      @action = meta['action']
      @entity = meta['entity']
      @id = meta['entity_id']
      @event = "#{entity}.#{action}"

      Rails.configuration.event_store.publish(
        PipedriveEvent.new(data: {
          event: event,
          id: @id
        }),
        stream_name: 'pipedrive'
      )
      ProcessPipedriveWebhookCommand.execute_for(inbound_webhook)

      inbound_webhook.processed!
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} for processing webhook failed: #{e}"
      Bugsnag.add_metadata("Webhook Data", inbound_webhook.params)
      Bugsnag.notify(e)
      inbound_webhook.failed!
    end

  end
end
