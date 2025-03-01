# Project: erp-rails
# Created Date: 2025-02-28
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class AddLeadToLemlistCampaignCommand < ApplicationCommand

  def call(event)
    raise "Incompatible event type" unless event.is_a?(BreakcoldStatusUpdateEvent)
    super
  end

  def initialize

  end

  def execute

  end

end
