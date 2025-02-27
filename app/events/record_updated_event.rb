# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class RecordUpdatedEvent < ApplicationEvent
  def record_type
    self.data[:record_type]
  end

  def record_id
    self.data[:record_id]
  end

  def event_type
    return "#{record_type} ##{record_id} (#{super})" unless record_type.blank?
    super
  end
end
