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
    client.import_person(payload)
    log "importing person... done!"
  end
end
