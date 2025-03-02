# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class CreateOrUpdateBreakcoldListCommand < BreakcoldCommand

  def entity
    'list'
  end

  def execute
    log "importing list..."
    record, result = client.import_list_with_id(payload)
    log "importing list... #{result} (#{record})"
    if record && (result == :imported || result == :updated)
      Rails.configuration.event_store.publish(
        RecordUpdatedEvent.new(data: {
          record_type: record.class.name,
          record_id: record.id,
        }),
        stream_name: 'breakcold',
      )
    end
    log "importing list... done!"
  end
end
