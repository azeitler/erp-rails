# Project: erp-rails
# Created Date: 2025-03-01
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class BreakcoldStatusUpdateEvent < BreakcoldEvent

  data_attribute :lead_id
  data_attribute :lead_current_status

  def lead
    return nil if lead_id.blank? || lead_id == 'not_found'
    @lead ||= Breakcold::Lead.unscoped.find_by(identifier: id)
  end

  def webhook
    return nil if data[:webhook].blank?
    @webhook ||= InboundWebhook.find_by_id(data[:webhook])
  end

  def new_status
    return nil if webhook.blank?
    statuses = webhook.params['payload']['status']
    statuses.map do |status|
      [ status['id_list'], status['name'] ]
    end.to_h
  end

  def status_changes
    return nil if new_status.blank?
    return nil if lead.blank?
    return nil if lead_current_status.blank?

    changes = []
    new_status.each do |list_id, new_status|
      old_status = lead_current_status[list_id]
      changes << {
        list_id: list_id,
        old_status: old_status,
        new_status: new_status
      }
    end
    changes
  end

  def status_changes_text
    return nil if status_changes.blank?
    status_changes.map do |change|
      "#{change[:old_status]} → #{change[:new_status]}"
    end.join(", ")
  end

  def event_label
    "#{lead&.title || 'lead_not_found'} status changed (#{status_changes_text}) (BreakcoldStatusUpdateEvent)"
  end

end
