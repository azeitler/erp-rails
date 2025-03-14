# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class PipedriveEvent < ApplicationEvent
  data_attribute :event
  data_attribute :id

  def event_label
    return "#{event} ##{id} (#{super})" unless event.blank?
    super
  end
end
