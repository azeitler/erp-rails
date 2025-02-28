# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class Breakcold::Person < Breakcold::Lead

  def linkedin_url
    properties['linkedin_url']
  end

  def company
    properties['company']
  end

  def linkedin_sales_nav?
    linkedin_url&.include?('/sales/')
  end

  def linkedin_type
    return :salesnav if linkedin_sales_nav?
    return :profile if linkedin_url&.include?('linkedin.com')
    :missing
  end
end
