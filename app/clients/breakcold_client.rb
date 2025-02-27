# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class BreakcoldClient < ImportClient
  BASE_URI = "https://api.breakcold.com/rest"

  def api_key
    @api_key ||= Rails.application.credentials.dig(:breakcold, :api_key)
  end

  def authorization_header
    {"X-API-KEY" => api_key }
  end

  def me
    get("/me").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load your account"
  end

  def tags
    get("/tags").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load tags"
  end

  def lists
    get("/lists").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load lists"
  end

  def leads
    response = post("/leads/list").parsed_body
    unless response['pagination']
      return response.leads
    end

    leads = response.leads
    page = response.pagination.page
    page_size = response.pagination.page_size
    total = 100 # response.total
    # iterate leads
    while leads.count < total
      puts "loading starting at lead no. #{page}, leads: #{leads.count}/#{total}"
      page_response = post("/leads/list", body: {pagination:{page:page+1, page_size:page_size}}).parsed_body
      leads += page_response.leads
      page = page_response.pagination.page
    end

    leads
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load lists"
  end

  # def attributes(object)
  #   get("/attributes").parsed_body
  # rescue *NET_HTTP_ERRORS
  #   raise Error, "Unable to load attributes"
  # end

  def import_leads
    log "importing leads..."
    updated = 0
    imported = 0
    with_timer do
      @leads = leads
      @leads.each do |lead|
        res = import_lead(lead)
        updated += 1 if res == 1
        imported += 1 if res == 2
      end
      deleted = 0
      deleted = prune_model(@leads.select{ |lead| lead.is_company }.map { |lead| lead['id'].to_s }, Breakcold::Company)
      deleted += prune_model(@leads.select{ |lead| !lead.is_company }.map { |lead| lead['id'].to_s }, Breakcold::Person)
      Breakcold::Lead.parse_all_and_save
      log "imported #{imported} leads, updated #{updated}, deleted #{deleted} leads out of #{@leads.count} leads"
    end
  end

  def import_lead(lead)
    unless lead.is_a?(OpenStruct)
      log "needs to be a OpenStruct" and return
    end
    lead_id = lead['id'].to_s
    breakcold_lead, result = import_model_with_id(lead.is_company ? Breakcold::Company : Breakcold::Person, lead_id) do |breakcold_lead|
      breakcold_lead.properties = lead.to_h
      breakcold_lead.type = lead.is_company ? "Breakcold::Company" : "Breakcold::Person"
      # puts "imported #{breakcold_lead.type} #{breakcold_lead.id} #{lead.id}"
    end
    breakcold_lead.parse_and_save
    result
  end

end
