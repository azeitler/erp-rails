module InboundWebhooks
  class LemlistJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      event = inbound_webhook.params['type']
      inbound_webhook.update_column(:event, event)
      id = inbound_webhook.params['leadId']

      Rails.configuration.event_store.publish(
        LemlistEvent.new(data: {
          webhook: inbound_webhook.id,
          event: event,
          id: id
        }),
        stream_name: 'lemlist'
      )
      ProcessLemlistWebhookCommand.execute_for(inbound_webhook)

      inbound_webhook.processed!
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} for processing webhook failed: #{e}"
      Bugsnag.add_metadata("Webhook Data", inbound_webhook.params)
      Bugsnag.notify(e)
      raise e if Rails.env.development?
      inbound_webhook.failed!
    end
  end
end
