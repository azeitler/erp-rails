# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteAcceptedCommand < LinkedinInviteCommand

  def validate!
    @errors << "event.sender_name is missing" if event.sender_name.blank?
    @errors << "event.recipient_linkedin_url is missing" if event.recipient_linkedin_url.blank?
    @errors << "event.recipient_name is missing" if event.recipient_name.blank?
    @errors << "event.breakcold_lead_id is missing" if event.breakcold_lead_id.blank?
    @errors << "event.breakcold_list_id is missing" if event.breakcold_list_id.blank?
    super
  end

  def execute
    Rails.logger.info "LinkedinInviteAcceptedCommand: execute #{event.inspect}"
    raise 'No event data' unless event

    LinkedinInviteAcceptedNotifier.with(account: Account.first, intro: event.notification_intro, message: event.notification_message, sender: event.campaign_name).deliver_later(User.all)

    # create the invite
    invite = find_or_create_invite(event.recipient_linkedin_url, event.sender_name, event.recipient_name)
    invite.update(accepted_at: DateTime.now, status: 'accepted', status_text: event.invite_text, properties: event.data)

    client = BreakcoldClient.new
    begin
      response = client.track_lead(event.breakcold_lead_id)
      Rails.configuration.event_store.publish(
        BreakcoldLeadTrackedEvent.new(data: {
          lead_id: event.breakcold_lead_id,
        }),
        stream_name: 'breakcold',
      )
    rescue StandardError => e
      Rails.logger.error("failed to track lead: #{e}", { command: self.inspect })
      Bugsnag.notify(e)
    end
  end
end
