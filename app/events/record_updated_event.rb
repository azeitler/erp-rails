# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class RecordUpdatedEvent < ApplicationEvent
  data_attribute :record_type
  data_attribute :record_id

  def event_label
    return "#{record_type} ##{record_id} (#{super})" unless record_type.blank?
    super
  end
end
