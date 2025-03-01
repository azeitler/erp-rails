# == Schema Information
#
# Table name: breakcold_leads
#
#  id           :bigint           not null, primary key
#  deleted      :boolean
#  deleted_at   :datetime
#  email        :string
#  identifier   :string
#  linkedin_url :string
#  properties   :jsonb
#  status       :jsonb
#  title        :string
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Breakcold::Person < Breakcold::Lead

  def linkedin_url
    url = properties['linkedin_url']
    return nil if url.blank?
    return url if url.include?('linkedin.com')
    "https://www.linkedin.com/in/#{url}"
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
