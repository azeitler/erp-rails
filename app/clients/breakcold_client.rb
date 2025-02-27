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
    if response.pagination.page_size < 2
      return response.leads
    end

    leads = response.leads
    # iterate pages
    page_size = response.pagination.page_size
    (2..page_size).each do |page|
      puts "loading page #{page}/#{page_size}, current leads: #{leads.count}"
      response = post("/leads/list", query:{cursor:page}).parsed_body
      leads += response.leads
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
      deleted = prune_model(@leads.map { |lead| lead['id'].to_s }, Breakcold::Lead)
      Breakcold::Lead.parse_all_and_save
      log "imported #{imported} leads, updated #{updated}, deleted #{deleted} leads out of #{leads.count} leads"
    end
  end

  def import_lead(lead)
    unless lead.is_a?(OpenStruct)
      log "needs to be a OpenStruct" and return
    end
    lead_id = lead['id'].to_s
    breakcold_lead, result = import_model_with_id(Breakcold::Lead, lead_id) do |breakcold_lead|
      breakcold_lead.properties = lead.to_h
      breakcold_lead.type = lead.is_company ? "Breakcold::Company" : "Breakcold::Person"
      breakcold_lead.title = lead['name']
    end
    breakcold_lead.parse_and_save
    result
  end

end
