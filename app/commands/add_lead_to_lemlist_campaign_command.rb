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

  def client
    @client ||= LemlistClient.new
  end

  def initialize

  end

  def execute
    if event.status_changes.blank?
      log "no status changes"
      return
    end

    log "checking for status changes #{event.status_changes}"
    event.status_changes.each do |status_change|
      execute_status_change(status_change)
    end
  end

  def execute_status_change(status_change)
    log "perform status change #{status_change}"
    list_id = status_change[:list_id]
    new_status = status_change[:new_status]

    unless new_status == 'To Connect'
      warn "status is not 'To Connect' (#{new_status})"
      return
    end

    log "status is 'To Connect' (#{new_status})"
    log "checking for campaign for list #{list_id}"
    list = Breakcold::List.find_by(identifier: list_id)
    if list.nil?
      warn "list #{list_id} not found"
      return
    end

    log "list #{list_id} found"
    if list.lemlist_campaign.nil?
      warn "no campaign set for list '#{list.title}' (#{list_id})"
      return
    end

    campaign = list.lemlist_campaign
    log "campaign #{campaign.title} (Lemlist) found for list #{list.title} (Breakcold List)"

    lead = event.lead
    log "lead #{lead.title} (#{lead.identifier}) found"

    log "adding lead #{lead.title} (#{lead.identifier}) to campaign #{campaign.title} (Lemlist)"
    begin
      lemlist_lead = client.add_breakcold_lead(campaign.identifier, list, lead)

      event_data = {
        breakcold_list: list.title,
        breakcold_list_id: list.identifier,
        lemlist_campaign: campaign.title,
        lemlist_campaign_id: campaign.identifier,
        lead: lead.title,
        lead_id: lead.identifier,
        status: new_status
      }
      event_store.publish(LeadAddedToLemlistCampaignEvent.new(data: event_data), stream_name: 'breakcold')

      log "lead #{lead.title} (#{lead.identifier}) added to campaign #{campaign.title} (Lemlist)"
    rescue => e
      error "error adding lead to campaign: #{e.message}"
    end
  end

end
