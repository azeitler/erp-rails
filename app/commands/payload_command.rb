# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class PayloadCommand < ApplicationCommand

  attr_reader :payload

  # @param [Hash] payload: data of the object (not wrapped into other fields)
  def initialize(payload)
    @payload = payload
  end

  def execute_command(command_klass)
    command_klass.new(payload).execute
  rescue StandardError => e
    Rails.logger.error "failed to execute command #{command_klass.name}: #{e}"
    Bugsnag.add_metadata("Command Payload", payload)
    Bugsnag.notify(e)
  end
end
