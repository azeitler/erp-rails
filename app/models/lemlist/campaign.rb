# == Schema Information
#
# Table name: lemlist_campaigns
#
#  id         :bigint           not null, primary key
#  identifier :string
#  properties :jsonb
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  persona_id :bigint
#
# Indexes
#
#  index_lemlist_campaigns_on_persona_id  (persona_id)
#
# Foreign Keys
#
#  fk_rails_...  (persona_id => personas.id)
#
class Lemlist::Campaign < ApplicationRecord
  include Helpers::Parsable

  belongs_to :persona, optional: true
  has_many :leads, class_name: 'Lemlist::Lead', foreign_key: 'lemlist_campaign_id'

  def status
    properties['status']
  end

  def parse

  end
end
