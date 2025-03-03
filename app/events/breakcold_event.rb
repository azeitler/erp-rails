# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class BreakcoldEvent < ApplicationEvent

  data_attribute :webhook
  data_attribute :id

  def event
    self.data['event']
  end

  def event_label
    return "#{event} (#{super})" unless event.blank?
    super
  end
end
