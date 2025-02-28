class Breakcold::List < ApplicationRecord
  include Helpers::Parsable
  has_and_belongs_to_many :leads, inverse_of: :lists, inverse_of: :lists, :class_name => 'Breakcold::Lead', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_list_id', association_foreign_key: 'breakcold_lead_id'
  has_and_belongs_to_many :people, :class_name => 'Breakcold::Person', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_list_id', association_foreign_key: 'breakcold_lead_id', scope: -> { Breakcold::Person.all }
  has_and_belongs_to_many :companies, :class_name => 'Breakcold::Company', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_list_id', association_foreign_key: 'breakcold_lead_id', scope: -> { Breakcold::Company.all }

  belongs_to :lemlist_campaign, optional: true, class_name: 'Lemlist::Campaign'

  def parse
    self.deleted = !properties['deleted_at'].blank?
    self.deleted_at = DateTime.parse(properties['deleted_at']) if properties['deleted_at']
  end
end
