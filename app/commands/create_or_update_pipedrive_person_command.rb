# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class CreateOrUpdatePipedrivePersonCommand < PipedriveCommand

  def entity
    'person'
  end

  def execute
    log "importing person..."
    record, result = client.import_person(payload)
    if record && (result == :imported || result == :updated)
      Rails.configuration.event_store.publish(
        RecordUpdatedEvent.new(data: {
          record_type: record.class.name,
          record_id: record.id,
        }),
        stream_name: 'pipedrive',
      )
    end
    log "importing person... done!"
  end
end
