module InboundWebhooks
  class PipedriveJob < ApplicationJob
    queue_as :default

    attr_reader :meta, :action, :event

    def perform(inbound_webhook)
      inbound_webhook.processing!

      # Process webhook
      @meta = inbound_webhook.params['meta']
      @action = meta['action']
      @entity = meta['entity']
      @event = "#{entity}.#{action}"

      begin
        ProcessPipedriveWebhookCommand.execute_for(inbound_webhook)
      rescue StandardError => e
        Rails.logger.error "#{self.class.name} for processing webhook failed: #{e}"
        Bugsnag.add_metadata("Webhook Data", inbound_webhook.params)
        Bugsnag.notify(e)
      end

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

    private
      def perform_for_person

      end

  end
end
