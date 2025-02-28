# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LinkedinInviteAcceptedEvent < ApplicationEvent
  # {
  #   "_id": "act_JMapFaFqB9dMLZpLL",
  #   "type": "linkedinInviteAccepted",
  #   "createdAt": "2025-02-27T14:58:05.000Z",
  #   "isFirst": true,
  #   "stopped": false,
  #   "bot": false,
  #   "teamId": "tea_hSBr4gYQ9J7ALq2P3",
  #   "leadId": "lea_fF8Zdhe5GEPdCEX4L",
  #   "campaignId": "cam_hSZJzm7qCv4Go6sfW",
  #   "sequenceId": "seq_5ACjKD32KecarG2M3",
  #   "sequenceStep": 1,
  #   "emailTemplateId": "etp_s7da488G9a2RXWpNF",
  #   "createdBy": "usr_PFnimcvkATCDEgwjJ",
  #   "sendUserId": "usr_iMkrf5Ax7xP3wo7bY",
  #   "totalSequenceStep": 2,
  #   "name": "🫅🏻🐘Bauma 2025",
  #   "sendUserName": "Chris Domagala",
  #   "leadFirstName": "Stefan",
  #   "leadLastName": "F",
  #   "leadPicture": "https://app.lemlist.com/api/files/Files/lip_336f3073f1c0055a7d831cfa6ebce63a.jpg",
  #   "contactId": "ctc_QfiCFBxSrQ3ED3QQS",
  #   "relatedSentAt": "2025-01-27T10:03:44.870Z",
  #   "metaData": {
  #     "teamId": "tea_hSBr4gYQ9J7ALq2P3",
  #     "campaignId": "cam_hSZJzm7qCv4Go6sfW",
  #     "leadId": "lea_fF8Zdhe5GEPdCEX4L",
  #     "type": "linkedinInviteAccepted",
  #     "createdBy": "usr_PFnimcvkATCDEgwjJ",
  #     "taskId": "tsk_MvRYsxA9ywGYsxAoH"
  #   },
  #   "campaignName": "🫅🏻🐘Bauma 2025",
  #   "firstName": "Stefan",
  #   "lastName": "F",
  #   "picture": "https://app.lemlist.com/api/files/Files/lip_336f3073f1c0055a7d831cfa6ebce63a.jpg",
  #   "linkedinUrl": "https://www.linkedin.com/sales/lead/ACwAAECzDM4BA-hzlNAPq6dfJGxNkM4bGG39Ld8,",
  #   "occupation": "Leiter Wartung und Instandhaltung",
  #   "Gender": "male",
  #   "labels": "Outreach; Personal",
  #   "emailTemplateName": "linkedinInvite"
  # }
  # event = event_store.publish(
  #   LinkedinInviteAcceptedEvent.new(data: {
  #     lead_id: payload['leadId'],
  #     lemlist_user_id: payload['sendUserId'],
  #     campaign_id: payload['campaignId'],
  #     campaign_name: payload['campaignName'],
  #     sender_name: payload['sendUserName'],
  #     recipient_name: ((payload['leadFirstName']||'') + ' ' + (payload['leadLastName']||'')).strip,
  #     recipient_picture: payload['leadPicture'],
  #     recipient_linkedin_url: payload['linkedinUrl'],
  #     recipient_occupation: payload['occupation'],
  #     recipient_company: payload['leadCompanyName'],
  #   }),
  #   stream_name: 'linkedin'
  # )

  data_attribute :lead_id
  data_attribute :lemlist_user_id
  data_attribute :campaign_id
  data_attribute :campaign_name
  data_attribute :sender_name
  data_attribute :recipient_name
  data_attribute :recipient_picture
  data_attribute :recipient_linkedin_url
  data_attribute :recipient_occupation
  data_attribute :recipient_company

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
