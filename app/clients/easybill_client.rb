# Project: erp-rails
# Created Date: 2025-03-05
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

require 'easybill/api'

class EasybillClient < ImportClient
  BASE_URI = "https://c78973.easybill.de"

  def access_token
    @access_token ||= Rails.application.credentials.dig(:easybill, :access_token)
  end

  def easybill_api
    @easybill_api ||= Easybill::Api::Client.new(access_token)
  end

  def page_limit
    @page_limit ||= 0
  end

  def page_limit=(limit)
    @page_limit = limit
  end

  def with_limit(pages)
    return pages if self.page_limit < 1
    [pages, self.page_limit].min
  end

  def documents
    all = []
    page = 0
    pages = 1
    begin
      while page < pages
        page += 1
        resp = easybill_api.documents.list(query: {page: page})
        all += resp['items']
        pages = with_limit(resp['pages'].to_i)
        log "Page[#{page}/#{pages}] #{all.count}/#{resp['total']} documents"
      end
    rescue Exception => ex
      log ex
    end
    all
  end

  def positions
    all = []
    page = 0
    pages = 1
    begin
      while page < pages
        page += 1
        resp = easybill_api.positions.list(query: {page: page})
        all += resp['items']
        pages = with_limit(resp['pages'].to_i)
        log "Page[#{page}/#{pages}] #{all.count}/#{resp['total']} positions"
      end
    rescue Exception => ex
      log ex
    end
    all
  end

  def position_groups
    @position_groups ||= begin
      all = []
      page = 0
      pages = 1
      begin
        while page < pages
          page += 1
          resp = easybill_api.position_groups.list(query: {page: page})
          all += resp['items']
          pages = with_limit(resp['pages'].to_i)
          log "Page[#{page}/#{pages}] #{all.count}/#{resp['total']} position_groups"
        end
      rescue Exception => ex
        log ex
      end
      all
    end
  end

  def customers
    all = []
    page = 0
    pages = 1
    begin
      while page < pages
        page += 1
        resp = easybill_api.customers.list(query: {page: page})
        all += resp['items']
        pages = with_limit(resp['pages'].to_i)
        log "Page[#{page}/#{pages}] #{all.count}/#{resp['total']} customers"
      end
    rescue Exception => ex
      log ex
    end
    all
  end

end
