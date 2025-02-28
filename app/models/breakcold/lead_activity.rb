# == Schema Information
#
# Table name: breakcold_lead_activities
#
#  id                :bigint           not null, primary key
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  breakcold_lead_id :bigint           not null
#
# Indexes
#
#  index_breakcold_lead_activities_on_breakcold_lead_id  (breakcold_lead_id)
#
# Foreign Keys
#
#  fk_rails_...  (breakcold_lead_id => breakcold_leads.id)
#
class Breakcold::LeadActivity < ApplicationRecord
  belongs_to :lead, class_name: 'Breakcold::Lead', foreign_key: 'breakcold_lead_id', inverse_of: :activities
end
