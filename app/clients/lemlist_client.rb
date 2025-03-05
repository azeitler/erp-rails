# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class LemlistClient < ImportClient
  BASE_URI = "https://api.lemlist.com/api"

  def api_key
    @api_key ||= Rails.application.credentials.dig(:lemlist, :api_key)
  end


  def authorization_header
    {
      "Authorization" => "Basic " + Base64.strict_encode64(":#{api_key}")
    }
  end


  def team
    get("/team").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load your account"
  end

  CAMPAIGNS_PER_PAGE = 100

  # /campaigns?limit=2&version=v2&page=1&sortBy=createdAt&sortOrder=desc
  def campaigns
    response = get("/campaigns", query: { limit: CAMPAIGNS_PER_PAGE, page: 1, version: 'v2', sortBy: 'createdAt', sortOrder: 'desc' }).parsed_body
    #<OpenStruct campaigns=[], pagination=#<OpenStruct totalRecords=59, currentPage=5, nextPage=2, totalPage=2>>

    unless response.pagination.totalPage > 1
      return response.campaigns
    end

    campaigns = response.campaigns
    page = response.pagination.currentPage
    page_size = response.pagination.totalPage
    total = response.pagination.totalRecords
    # iterate campaigns
    while campaigns.count < total
      puts "loading starting at campaign page #{page}, campaigns: #{campaigns.count}/#{total}"
      page_response = get("/campaigns", query: { limit: CAMPAIGNS_PER_PAGE, page: page + 1, version: 'v2', sortBy: 'createdAt', sortOrder: 'desc' }).parsed_body
      campaigns += page_response.campaigns
      page = page_response.pagination.currentPage
    end

    campaigns
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load lists"
  end

  def campaign(campaign_id)
    get("/campaigns/#{campaign_id}").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load campaign"
  end

  def leads(campaign_id)
    # campaigns/:campaignId/export/leads?state=all&format=json
    get("/campaigns/#{campaign_id}/export/leads", query: { state: 'all', format: 'json' }).parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load campaign"
  end

  def add_breakcold_lead(campaign_id, list, lead)
    # campaigns/:campaignId/leads
    data = {
      'linkedinUrl': lead.linkedin_url.strip,
      'firstName': lead.first_name.strip,
      'lastName': lead.last_name.strip,
      # 'preferredContactMethod': 'linkedIn',
      'leadSource': 'breakcold',
      'breakcoldLeadId': lead.identifier,
      'breakcoldListId': list.identifier,
    }
    data['companyName'] = lead.company.strip if lead.company.present?
    data['jobTitle'] = lead.company_position.strip if lead.company_position.present?
    data['language'] = lead.language.strip if lead.language.present?

    puts "adding lead to campaign #{campaign_id}: #{data}"
    lead_response = post("/campaigns/#{campaign_id}/leads", query: { 'findEmail': true, 'linkedinEnrichment': true  }, body: data.to_json, headers: { "Content-Type" => "application/json" }).parsed_body
    puts "lead added to campaign #{campaign_id}: #{lead_response}"

    import_lead(lead_response)

    lead_response
  rescue *NET_HTTP_ERRORS, ApplicationClient::InternalError => e
    raise Error, "Unable to add lead to campaign: #{e.message}"
  end

  def add_variables_to_lead(lead_id, variables)
    # leads/:leadId/variables
    post("/leads/#{lead_id}/variables", body: variables.to_json, headers: { "Content-Type" => "application/json" }).parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to add variable to lead"
  end

  def import_campaign_with_id(campaign_id)
    _campaign = campaign(campaign_id)
    import_campaign(_campaign)
  end

  def import_campaigns
    log "importing campaigns..."
    updated = 0
    imported = 0
    with_timer do
      @campaigns = campaigns
      @campaigns.each do |campaign|
        res = import_campaign(campaign)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
      end
      deleted = prune_model(@campaigns.map { |campaign| campaign['_id'].to_s }, Lemlist::Campaign)
      Lemlist::Campaign.parse_all_and_save
      log "imported #{imported} campaigns, updated #{updated}, deleted #{deleted} campaigns out of #{@campaigns.count} campaigns"
    end
    @campaigns
  end

  def import_campaign(campaign)
    unless campaign.is_a?(OpenStruct) || campaign.is_a?(Hash)
      log "import_campaign: needs to be a OpenStruct" and return
    end
    campaign_id = campaign['_id'].to_s
    lemlist_campaign, result = import_model_with_id(Lemlist::Campaign, campaign_id) do |lemlist_campaign|
      lemlist_campaign.properties = campaign.to_h
      lemlist_campaign.title = campaign['name']
      # lemlist_campaign.created_at = DateTime.parse(campaign['created_at']) if campaign['created_at']
      # puts "imported #{lemlist_campaign.type} #{lemlist_campaign.id} #{campaign.id}"
    end
    lemlist_campaign.parse_and_save
    result
  end

  def import_all
    _campaigns = import_campaigns
    leads = []
    _campaigns.each_with_index do |campaign, index|
      log "[#{index+1}/#{_campaigns.count}] importing leads from campaign #{campaign['name']}..."
      campaignId = campaign['_id'].to_s
      _leads = leads(campaignId)
      _leads.each do |lead|
        lead['campaign_id'] = campaignId
      end
      leads += _leads
      log "[#{index+1}/#{_campaigns.count}] importing leads from campaign #{campaign['name']}... done -> #{leads.count} leads"
    end
    log "will import #{leads.count} leads..."
    import_leads(leads)
    log "imported #{leads.count} leads"
    true
  end

  def import_leads_from_campaign(campaign_id)
    leads = leads(campaign_id)
    import_leads(leads)
  end

  def import_leads(leads)
    log "importing #{leads.count} leads..."
    updated = 0
    imported = 0
    with_timer do
      @leads = leads
      @leads.each do |lead|
        res = import_lead(lead)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
      end
      deleted = prune_model(@leads.map { |lead| lead['_id'].to_s }, Lemlist::Lead)
      Lemlist::Lead.parse_all_and_save
      log "imported #{imported} leads, updated #{updated}, deleted #{deleted} leads out of #{@leads.count} leads"
    end
  end

  def import_lead(lead)
    unless lead.is_a?(OpenStruct) || lead.is_a?(Hash)
      log "import_lead: needs to be a OpenStruct" and return
    end
    lead_id = lead['_id'].to_s
    lemlist_lead, result = import_model_with_id(Lemlist::Lead, lead_id) do |lemlist_lead|
      lemlist_lead.properties = lead.to_h
      # lemlist_lead.created_at = DateTime.parse(lead['created_at']) if lead['created_at']
      # puts "imported #{lemlist_lead.type} #{lemlist_lead.id} #{lead.id}"
    end
    lemlist_lead.parse_and_save
    result
  end

end
