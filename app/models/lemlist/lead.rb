# == Schema Information
#
# Table name: lemlist_leads
#
#  id                  :bigint           not null, primary key
#  email               :string
#  identifier          :string
#  linkedin_url        :string
#  properties          :jsonb
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lemlist_campaign_id :bigint
#
# Indexes
#
#  index_lemlist_leads_on_lemlist_campaign_id  (lemlist_campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (lemlist_campaign_id => lemlist_campaigns.id)
#
class Lemlist::Lead < ApplicationRecord
  include Helpers::Parsable

  belongs_to :campaign, class_name: 'Lemlist::Campaign', foreign_key: 'lemlist_campaign_id', optional: true

  def name
    ((properties['firstName'] || "") + " " + (properties['lastName'] || "")).strip
  end

  def company
    properties['companyName']
  end

  def linkedin_url
    properties['linkedinUrl']
  end

  def linkedin_sales_nav?
    linkedin_url&.include?('/sales/')
  end

  def linkedin_type
    return :salesnav if linkedin_sales_nav?
    return :profile if linkedin_url&.include?('linkedin.com')
    :missing
  end

  def avatar_url
    properties['avatar_url']
  end

  def campaign_id
    properties['campaign_id']
  end

  def parse
    self.email = properties['email']
    self.title = name
    unless campaign_id.blank?
      self.campaign = Lemlist::Campaign.find_by_identifier(campaign_id)
    else
      self.campaign = nil
    end
  end
end
