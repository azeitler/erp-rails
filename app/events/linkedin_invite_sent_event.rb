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

  def notification_message
    "#{recipient_name} (#{recipient_occupation} bei #{recipient_company})"
  end

  def notification_intro
    "hat die LinkedIn-Einladung von #{sender_name} angenommen!"
  end

  def event_label
    "#{recipient_name} (#{recipient_occupation} bei #{recipient_company}) by #{sender_name} (#{super})"
  end

end
