# == Schema Information
#
# Table name: linkedin_invites
#
#  id              :bigint           not null, primary key
#  accepted_at     :datetime
#  linkedin_url    :string
#  person          :string
#  properties      :jsonb
#  status          :string
#  status_text     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  from_persona_id :integer
#
class Linkedin::Invite < ApplicationRecord
  default_scope { order(updated_at: :desc) }

  belongs_to :from_persona, class_name: "Persona"
end
