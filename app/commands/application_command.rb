# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class ApplicationCommand
  # @abstract
  def execute
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def call(event)
    @event = event
    execute
  end

  def to_s
    "[#{self.class.name}]"
  end

  def log(str)
    Rails.logger.info "#{self} #{str}"
  end

  private

  def event_store
    Rails.configuration.event_store
  end
end
