# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteSentEvent < ApplicationEvent
  data_attribute :lead_id
  data_attribute :lead_source
  data_attribute :lemlist_user_id
  data_attribute :campaign_id
  data_attribute :campaign_name
  data_attribute :sender_name
  data_attribute :email
  data_attribute :invite_text
  data_attribute :recipient_name
  data_attribute :recipient_picture
  data_attribute :recipient_linkedin_url
  data_attribute :recipient_occupation
  data_attribute :recipient_company
  data_attribute :breakcold_lead_id
  data_attribute :breakcold_list_id

  def company_or_fallback
    return self.recipient_company unless self.recipient_company.blank?
    unless self.email.blank?
      domain = self.email.split('@').last
      return domain unless domain.blank?
    end
    "<Firma unbekannt>"
  end

  def notification_message
    "#{self.recipient_name} (#{self.recipient_occupation} bei #{self.recipient_company})"
  end

  def notification_intro
    "LinkedIn-Einladung über #{self.sender_name} versendet!"
  end

  def event_label
    # return self.inspect
    "#{self.recipient_name} (#{self.recipient_occupation} bei #{self.company_or_fallback}) by #{self.sender_name} (#{super})"
  end

end
