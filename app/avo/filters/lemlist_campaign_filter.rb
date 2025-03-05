# Project: erp-rails
# Created Date: 2025-03-05
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class Avo::Filters::LemlistCampaignFilter < Avo::Filters::SelectFilter
  self.name = "Campaign"

  def apply(request, query, value)
    if value.present?
      controller = value
      if controller.present?
        query = query.where(controller_name: controller)
      end
    end
    query
  end

  def options
    Lemlist::Campaign.pluck(:id).uniq.sort_by(&:to_s).each_with_object({}) do |campaign_id, options|
      campaign = Lemlist::Campaign.find(campaign_id)
      options[campaign_id] = "#{campaign.title} (#{Lemlist::Lead.where(lemlist_campaign_id:campaign_id).count})"
    end
  end
end
