# == Schema Information
#
# Table name: inbound_webhooks
#
#  id              :bigint           not null, primary key
#  status          :integer          default("pending"), not null
#  body            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  controller_name :string
#  action_name     :string
#  ip_address      :string
#  user_agent      :string
#  headers         :jsonb
#
class InboundWebhook < ApplicationRecord
  cattr_accessor :incinerate_after, default: 30.days
  enum :status, %i[pending processing processed failed]

  after_update_commit :incinerate_later, if: -> { status_previously_changed? && processed? }

  def params
    JSON.parse(body || '{}')
  end

  def incinerate_later
    InboundWebhooks::IncinerationJob.set(wait: incinerate_after).perform_later(self)
  end
end
