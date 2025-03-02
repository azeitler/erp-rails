# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteSentCommand < LinkedinInviteCommand

  def execute
    Rails.logger.info "LinkedinInviteSentCommand: execute #{event.inspect}"
    raise 'No event data' unless event

    # create the invite
    invite = find_or_create_invite(event.recipient_linkedin_url, event.sender_name, event.recipient_name)
    log "Event: #{event.inspect}"
    invite.update(status: 'sent', status_text: event.invite_text, properties: event.data) # , created_at: event.created_at)
  end
end
