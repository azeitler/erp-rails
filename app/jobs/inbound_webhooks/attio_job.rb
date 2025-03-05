module InboundWebhooks
  class AttioJob < ApplicationJob
    queue_as :default

    attr_reader :events

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      events = inbound_webhook.params['events']
      event = events.map{|evt| evt['event_type']}.join(', ')
      inbound_webhook.update_column(:event, event)

      inbound_webhook.processed!
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} for processing webhook failed: #{e}"
      Bugsnag.add_metadata("Webhook Data", inbound_webhook.params)
      Bugsnag.notify(e)
      inbound_webhook.failed!
    end
  end
end
