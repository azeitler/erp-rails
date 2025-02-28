class Breakcold::LeadActivity < ApplicationRecord
  belongs_to :lead, class_name: 'Breakcold::Lead', foreign_key: 'breakcold_lead_id', inverse_of: :activities
end
