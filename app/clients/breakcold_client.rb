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

  def list(list_id)
    _lists = lists
    _lists.detect { |list| list.id == list_id }
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load list"
  end

  def statuses
    get("/status", query: {all:true}).parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load statuses"
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
        updated += 1 if res == :updated
        imported += 1 if res == :imported
      end
      deleted = prune_model(@leads.select{ |lead| lead['is_company'] }.map { |lead| lead['id'].to_s }, Breakcold::Company)
      deleted += prune_model(@leads.select{ |lead| !lead['is_company'] }.map { |lead| lead['id'].to_s }, Breakcold::Person)
      Breakcold::Lead.parse_all_and_save
      log "imported #{imported} leads, updated #{updated}, deleted #{deleted} leads out of #{@leads.count} leads"
    end
  end

  def import_lead(lead)
    unless lead.is_a?(OpenStruct) || lead.is_a?(Hash)
      log "import_lead: needs to be a OpenStruct" and return
    end
    lead_id = lead['id'].to_s
    breakcold_lead, result = import_model_with_id(lead['is_company'] ? Breakcold::Company : Breakcold::Person, lead_id) do |breakcold_lead|
      breakcold_lead.properties = lead.to_h
      breakcold_lead.type = lead['is_company'] ? "Breakcold::Company" : "Breakcold::Person"
      # puts "imported #{breakcold_lead.type} #{breakcold_lead.id} #{lead.id}"
    end
    breakcold_lead.parse_and_save
    result
  end

  def import_lists
    log "importing lists..."
    updated = 0
    imported = 0
    with_timer do
      @lists = lists
      @lists.each do |list|
        res = import_list(list)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
      end
      deleted = prune_model(@lists.map { |list| list['id'].to_s }, Breakcold::List)
      Breakcold::List.parse_all_and_save
      log "imported #{imported} lists, updated #{updated}, deleted #{deleted} lists out of #{@lists.count} lists"
    end
  end

  def import_list_with_id(list_id)
    list = list(list_id)
    import_list(list)
  end

  def import_list(list)
    unless list.is_a?(OpenStruct) || list.is_a?(Hash)
      log "import_list: needs to be a OpenStruct" and return
    end
    list_id = list['id'].to_s
    breakcold_list, result = import_model_with_id(Breakcold::List, list_id) do |breakcold_list|
      breakcold_list.properties = list.to_h
      breakcold_list.title = list['name']
      # puts "imported #{breakcold_list.type} #{breakcold_list.id} #{list.id}"
    end
    breakcold_list.parse_and_save
    result
  end

  def statuses_for_list(list_id)
    all_statuses = statuses
    all_statuses.select { |status| status['id_list'].to_s == list_id.to_s }
  end

  def import_statuses_for_list(list_id)
    list_statuses = statuses_for_list(list_id)
    import_statuses(list_statuses)
  end

  def import_statuses(statuses)
    log "importing status..."
    updated = 0
    imported = 0
    with_timer do
      statuses.each do |status|
        res = import_status(status)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
      end
      deleted = prune_model(statuses.map { |status| status['id'].to_s }, Breakcold::Status)
      Breakcold::Status.parse_all_and_save
      log "imported #{imported} status, updated #{updated}, deleted #{deleted} status out of #{statuses.count} status"
    end
  end

  def import_status(status)
    unless status.is_a?(OpenStruct) || status.is_a?(Hash)
      log "import_status: needs to be a OpenStruct" and return
    end
    status_id = status['id'].to_s
    breakcold_status, result = import_model_with_id(Breakcold::Status, status_id) do |breakcold_status|
      breakcold_status.properties = status.to_h
      breakcold_status.title = status['name']
      # puts "imported #{breakcold_status.type} #{breakcold_status.id} #{status.id}"
    end
    breakcold_status.parse_and_save
    result
  end

end
