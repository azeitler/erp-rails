module InboundWebhooks
  class BreakcoldJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      event = inbound_webhook.params['event']
      inbound_webhook.update_column(:event, event)
      id = inbound_webhook.params['payload']['id']

      Rails.configuration.event_store.publish(
        BreakcoldEvent.new(data: {
          webhook: inbound_webhook.id,
          event: event,
          id: id
        }),
        stream_name: 'breakcold'
      )
      ProcessBreakcoldWebhookCommand.execute_for(inbound_webhook)

      inbound_webhook.processed!
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} for processing webhook failed: #{e}"
      Bugsnag.add_metadata("Webhook Data", inbound_webhook.params)
      Bugsnag.notify(e)
      inbound_webhook.failed!
    end
  end
end
