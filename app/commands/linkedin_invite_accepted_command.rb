# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteAcceptedCommand < ApplicationCommand

  def execute
    raise 'No event data' unless event
    LinkedinInviteAcceptedNotifier.with(message: event.notification_message).deliver_later(User.first)
  end
end
