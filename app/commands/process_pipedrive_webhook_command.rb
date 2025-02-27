# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class ProcessPipedriveWebhookCommand < PipedriveCommand

  def self.execute_for(inbound_webhook)
    ProcessPipedriveWebhookCommand.new(inbound_webhook.params).execute
  end

  attr_accessor :meta, :entity, :action, :event

  # @param [Hash] payload from the webhook, contains 'data' and 'meta'
  def initialize(payload)
    @meta = payload['meta']
    @action = meta['action']
    @entity = meta['entity']
    @id = meta['entity_id']
    @event = "#{entity}.#{action}"

    super(payload['data'])
  end

  def execute
    # log event

    # puts "SimpleCommand: See, I can do simple things like printing (#{@payload})"
    case entity
      when 'person'
        execute_for_person
      else
        # raise StandardError.new("Webhook cannot be processed #{event} (unsupported entity)")
        Rails.logger.warn("Webhook cannot be processed #{event} (unsupported entity)")
    end
  end

  private
  def execute_for_person
    case action
      when 'create', 'change'
        execute_command(CreateOrUpdatePipedrivePersonCommand)
      else
        raise StandardError.new("Webhook cannot be processed #{event} (unsupported action)")
    end
  end

end
