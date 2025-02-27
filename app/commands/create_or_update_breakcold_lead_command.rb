# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class CreateOrUpdateBreakcoldLeadCommand < BreakcoldCommand

  def entity
    'lead'
  end

  def execute
    log "importing lead..."
    record, result = client.import_lead(payload)
    if record && (result == :imported || result == :updated)
      Rails.configuration.event_store.publish(
        RecordUpdatedEvent.new(data: {
          record_type: record.class.name,
          record_id: record.id,
        }),
        stream_name: 'breakcold',
      )
    end
    log "importing lead... done!"
  end
end
