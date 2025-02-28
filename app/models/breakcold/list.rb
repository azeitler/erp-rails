# == Schema Information
#
# Table name: breakcold_lists
#
#  id                  :bigint           not null, primary key
#  deleted             :boolean
#  deleted_at          :datetime
#  identifier          :string
#  properties          :jsonb
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  lemlist_campaign_id :bigint
#
# Indexes
#
#  index_breakcold_lists_on_lemlist_campaign_id  (lemlist_campaign_id)
#
# Foreign Keys
#
#  fk_rails_...  (lemlist_campaign_id => lemlist_campaigns.id)
#
class Breakcold::List < Breakcold::BaseRecord
  include Helpers::Parsable

  # default_scope { where(deleted: false).order(title: :asc) }
  default_scope { order(title: :asc) }

  has_and_belongs_to_many :leads, inverse_of: :lists, :class_name => 'Breakcold::Lead', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_list_id', association_foreign_key: 'breakcold_lead_id'
  has_and_belongs_to_many :people, :class_name => 'Breakcold::Person', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_list_id', association_foreign_key: 'breakcold_lead_id', scope: -> { Breakcold::Person.all }
  has_and_belongs_to_many :companies, :class_name => 'Breakcold::Company', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_list_id', association_foreign_key: 'breakcold_lead_id', scope: -> { Breakcold::Company.all }

  belongs_to :lemlist_campaign, optional: true, class_name: 'Lemlist::Campaign'

  has_many :statuses, class_name: 'Breakcold::Status', foreign_key: 'breakcold_list_id', dependent: :destroy, inverse_of: :list

  def parse
    self.properties = normalize_properties
    self.deleted = !properties['deleted_at'].blank?
    self.deleted_at = DateTime.parse(properties['deleted_at']) if properties['deleted_at']

    parse_created_at
    parse_updated_at
  end
end
