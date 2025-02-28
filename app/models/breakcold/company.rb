# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class Breakcold::Company < Breakcold::Lead

  def linkedin_url
    properties['linkedin_company_url'] || properties['linkedin_url']
  end

  def avatar_url
    properties['avatar_url']
  end

  def linkedin_type
    return :profile if linkedin_url&.include?('linkedin.com')
    :missing
  end
end

