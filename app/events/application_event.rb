# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class ApplicationEvent < RailsEventStore::Event

  # define method to access self.data
  def self.data_attribute(key, default = nil)
    attr_reader key
    define_method(key) do
      data[key] || default
    end
  end

  def self.event_store
    Rails.configuration.event_store
  end

  def event_label
    event_type
  end

end
