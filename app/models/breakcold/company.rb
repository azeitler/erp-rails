# == Schema Information
#
# Table name: breakcold_leads
#
#  id           :bigint           not null, primary key
#  deleted      :boolean
#  deleted_at   :datetime
#  email        :string
#  identifier   :string
#  language     :string
#  linkedin_url :string
#  properties   :jsonb
#  status       :jsonb
#  title        :string
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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

