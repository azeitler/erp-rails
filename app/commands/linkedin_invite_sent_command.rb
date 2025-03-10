# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteSentCommand < LinkedinInviteCommand

  def validate!
    @errors << "event.sender_name is missing" if event.sender_name.blank?
    @errors << "event.recipient_linkedin_url is missing" if event.recipient_linkedin_url.blank?
    @errors << "event.recipient_name is missing" if event.recipient_name.blank?
    @errors << "event.breakcold_lead_id is missing" if event.breakcold_lead_id.blank?
    @errors << "event.breakcold_list_id is missing" if event.breakcold_list_id.blank?
    super
  end

  def execute
    Rails.logger.info "LinkedinInviteSentCommand: execute #{event.inspect}"
    raise 'No event data' unless event

    # create the invite
    invite = find_or_create_invite(event.recipient_linkedin_url, event.sender_name, event.recipient_name)
    log "Event: #{event.inspect}"
    invite.update(status: 'sent', status_text: event.invite_text, properties: event.data, created_at: event.metadata[:timestamp])

    # update lead in Breakcold
    # breakcold_lead_id: payload['breakcoldLeadId'],
    # breakcold_list_id: payload['breakcoldListId'],

    list_id = event.breakcold_list_id
    list = Breakcold::List.find_by(identifier: list_id)
    raise "list with ID not found '#{list_id}'" if list.nil?

    lead = Breakcold::Person.find_by(identifier: event.breakcold_lead_id)
    lead = Breakcold::Person.find_by(linkedin_url: event.recipient_linkedin_url) if lead.nil?
    raise "lead with ID not found '#{event.breakcold_lead_id}'" if lead.nil?

    client = BreakcoldClient.new

    # lets get the current status
    current_status = lead.status_for_list(list_id)
    if current_status.blank?
      raise "lead '#{lead.title}' has no status for list '#{list.title}' (#{list_id})"
    end
    current_status_id = current_status['id']

    # get the id of the new status
    new_status_name = 'LI invite sent'
    # FIXME: use role!
    new_status = Breakcold::Status.find_by(title: new_status_name, breakcold_list_id: list.id)
    new_status_id = new_status.identifier

    client.update_lead(lead.identifier, current_status_id, new_status_id)
  end
end
