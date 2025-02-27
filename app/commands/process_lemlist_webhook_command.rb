# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class ProcessLemlistWebhookCommand < LemlistCommand

  attr_accessor :event

  def self.execute_for(inbound_webhook)
    ProcessLemlistWebhookCommand.new(inbound_webhook.params).execute
  end

  def initialize(data)
    @event = data['type']
    @id = data['leadId']
    super(data)
  end

  def execute
    case event
      when 'linkedinInviteAccepted'
        # execute_command(CreateOrUpdateBreakcoldCommand)
      else
        # raise StandardError.new("Webhook cannot be processed #{event} (unsupported action)")
        Rails.logger.warn("Webhook cannot be processed #{event} (unsupported action)")
    end
  end

end
