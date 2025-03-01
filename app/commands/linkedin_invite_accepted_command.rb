# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteAcceptedCommand < LinkedinInviteCommand

  def execute
    Rails.logger.info "LinkedinInviteAcceptedCommand: execute #{event.inspect}"
    raise 'No event data' unless event

    LinkedinInviteAcceptedNotifier.with(account: Account.first, intro: event.notification_intro, message: event.notification_message, sender: event.campaign_name).deliver_later(User.all)

    # create the invite
    invite = find_or_create_invite(event.recipient_linkedin_url, event.sender_name, event.recipient_name)
    invite.update(accepted_at: DateTime.now, status: 'accepted')
  end
end
