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
