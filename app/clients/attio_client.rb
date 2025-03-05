# Project: erp-rails
# Created Date: 2025-03-05
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class AttioClient < ImportClient
  BASE_URI = "https://api.attio.com/v2"

  def access_token
    @access_token ||= Rails.application.credentials.dig(:attio, :access_token)
  end


  def authorization_header
    {
      "Authorization" => "Basic " + Base64.strict_encode64("#{access_token}:")
    }
  end

  def objects
    get("/objects").parsed_body
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load objects"
  end



  PEOPLE_PER_PAGE = 200

  def people(total=nil)
    response = post("/objects/people/records/query", body: { limit: PEOPLE_PER_PAGE, offset: 0 }).parsed_body

    if response.data.count < PEOPLE_PER_PAGE
      puts "single page response #{response.data.count}"
      return response.data
    end

    _people = response.data
    _last_count = response.data.count
    offset = PEOPLE_PER_PAGE
    while _last_count == PEOPLE_PER_PAGE
      if total && _people.count >= total
        return _people[0..total-1]
      end

      puts "loading starting at people #{offset}, people: #{_people.count}"
      page_response = post("/objects/people/records/query", body: { limit: PEOPLE_PER_PAGE, offset: offset }).parsed_body
      _people += page_response.data
      _last_count = page_response.data.count
      offset += PEOPLE_PER_PAGE
    end

    puts "loaded #{_people.count} people"
    _people
  rescue *NET_HTTP_ERRORS
    raise Error, "Unable to load lists"
  end

end
