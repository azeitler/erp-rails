# Project: erp-rails
# Created Date: 2025-03-02
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LeadAddedToLemlistCampaignEvent < ApplicationEvent
  data_attribute :lead
  data_attribute :breakcold_list
  data_attribute :lemlist_campaign
  data_attribute :status

  def event_label
    "#{lead} #{breakcold_list}[Breakcold] #{lemlist_campaign}[Lemlist] (#{super})"
  end
end
