# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkEventToStreamCommand < ApplicationCommand

  def initialize(stream)
    @stream = stream
  end

  def call(event)
    event_store.link(event.event_id, stream_name: @stream)
  end
end
