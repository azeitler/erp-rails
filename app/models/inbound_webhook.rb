# == Schema Information
#
# Table name: inbound_webhooks
#
#  id              :bigint           not null, primary key
#  action_name     :string
#  body            :text
#  controller_name :string
#  event           :string
#  headers         :jsonb
#  ip_address      :string
#  status          :integer          default("pending"), not null
#  user_agent      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
