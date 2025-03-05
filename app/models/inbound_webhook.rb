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
    @params ||= JSON.parse(body || '{}')
  end

  def pipedrive_person
    if controller_name == 'InboundWebhooks::PipedriveController'
      if params['meta'] && params['meta']['entity'] == 'person'
        return PipedriveCrm::Person.find_by_identifier(params['meta']['entity_id'])
      end
    end
  end

  def label
    if params
      str = []
      str << params['event'] if params['event']
      str << params['type'] if params['type']

      str << params['first_name'] if params['first_name']
      str << params['last_name'] if params['last_name']
      str << params['firstName'] if params['firstName']
      str << params['lastName'] if params['lastName']
      if params['payload']
        payload = params['payload']
        str << payload['first_name'] if payload['first_name']
        str << payload['last_name'] if payload['last_name']
        str << payload['firstName'] if payload['firstName']
        str << payload['lastName'] if payload['lastName']
      end
      return str.join(' ') + " (#{controller_name})" if str.any?
    end
    "#{controller_name}"
  end

  def incinerate_later
    InboundWebhooks::IncinerationJob.set(wait: incinerate_after).perform_later(self)
  end
end
