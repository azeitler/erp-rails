# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class ProcessBreakcoldWebhookCommand < BreakcoldCommand

  attr_accessor :event

  def self.execute_for(inbound_webhook)
    ProcessBreakcoldWebhookCommand.new(inbound_webhook.params).execute
  end

  def initialize(data)
    @event = data['event']
    @id = data['payload']['id']

    super(data['payload'])
  end

  def execute
    case event
      when 'lead.status.update', 'lead.create', 'lead.update'
        execute_command(CreateOrUpdateBreakcoldCommand)
      else
        # raise StandardError.new("Webhook cannot be processed #{event} (unsupported action)")
        Rails.logger.warn "Webhook cannot be processed #{event} (unsupported action)"
    end
  end

end
