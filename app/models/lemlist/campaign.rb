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
