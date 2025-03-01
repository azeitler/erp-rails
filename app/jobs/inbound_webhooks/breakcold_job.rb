module InboundWebhooks
  class BreakcoldJob < ApplicationJob
    queue_as :default

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      event = inbound_webhook.params['event']
      inbound_webhook.update_column(:event, event)
      id = inbound_webhook.params['payload']['id']
      event_data = {
          webhook: inbound_webhook.id,
          event: event,
          id: id
        }

      # populate the event with the current lead status data
      if event.starts_with?('lead.')
        lead = Breakcold::Lead.find_by(identifier: id)
        if lead
          event_data[:lead_id] = lead.id
          event_data[:lead_current_status] = lead.status
        else
          event_data[:lead_id] = 'not_found'
        end
      end

      if event == 'lead.status.update'
        event_store.publish(
          BreakcoldStatusUpdateEvent.new(data: event_data),
          stream_name: 'breakcold'
        )
      else
        event_store.publish(
          BreakcoldEvent.new(data: event_data),
          stream_name: 'breakcold'
        )
        ProcessBreakcoldWebhookCommand.execute_for(inbound_webhook)
      end


      inbound_webhook.processed!
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} for processing webhook failed: #{e}"
      Bugsnag.add_metadata("Webhook Data", inbound_webhook.params)
      Bugsnag.notify(e)
      inbound_webhook.failed!
    end
  end
end
