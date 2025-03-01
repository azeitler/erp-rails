# Project: erp-rails
# Created Date: 2025-03-02
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteCommand < ApplicationCommand
  self.abstract_class = true

  #  created_at      :datetime         not null
  #  updated_at      :datetime         not null
  #  linkedin_url    :string
  #  person          :string
  #  from_persona_id :integer
  #  accepted_at     :datetime
  #  identifier      :string
  #  status          :string
  def find_or_create_invite(linkedin_url, sender_name, contact_name)
    sender = Persona.find_or_create_by!(name: sender_name.strip)
    invite = Invite.find_or_create_by!(linkedin_url: linkedin_url.strip, from_persona_id: sender.id)
    invite.update(person: contact_name.strip)
    invite
  end
end
