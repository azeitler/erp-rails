# Project: erp-rails
# Created Date: 2025-02-28
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class AddLeadToLemlistCampaignCommand < ApplicationCommand
  # attr_accessor :lead, :campaign
  #
  # def self.execute_for(lead, campaign)
  #   AddLeadToLemlistCampaignCommand.new(lead, campaign).execute
  # end
  #
  # def initialize(lead, campaign)
  #   @lead = lead
  #   @campaign = campaign
  # end
  #
  # def call(event)
  #   super
  #   self.lead = event.data[:lead]
  # end
  #
  # def execute
  #   return unless lead&.email.present?
  #
  #   if campaign.present?
  #     Lemlist::AddLeadToCampaignCommand.execute_for(lead, campaign)
  #   else
  #     Rails.logger.error("No campaign found for #{lead.email}")
  #   end
  # end
end
