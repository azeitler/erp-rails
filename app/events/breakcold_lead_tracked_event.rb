# Project: erp-rails
# Created Date: 2025-03-04
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class BreakcoldLeadTrackedEvent < BreakcoldEvent

  data_attribute :lead_id

  def lead
    return nil if lead_id.blank? || lead_id == 'not_found'
    @lead ||= Breakcold::Lead.unscoped.find_by(identifier: lead_id)
  end

  def event_label
    "#{lead&.title || 'lead_not_found'} tracked (BreakcoldLeadTrackedEvent)"
  end

end
