# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteAcceptedCommand < ApplicationCommand

  def execute
    Rails.logger.info "LinkedinInviteAcceptedCommand: execute #{event.inspect}"

    raise 'No event data' unless event
    LinkedinInviteAcceptedNotifier.with(account: Account.first, intro: event.notification_intro, message: event.notification_message, sender: event.campaign_name).deliver_later(User.all)

    # find or create persona for sender
    sender = Persona.find_or_create_by!(name: event.sender_name)

  end
end
