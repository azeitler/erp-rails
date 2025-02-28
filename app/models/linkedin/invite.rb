# == Schema Information
#
# Table name: linkedin_invites
#
#  id              :bigint           not null, primary key
#  accepted_at     :datetime
#  identifier      :string
#  linkedin_url    :string
#  person          :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  from_persona_id :integer
#
class Linkedin::Invite < ApplicationRecord
end
