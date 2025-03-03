# == Schema Information
#
# Table name: breakcold_statuses
#
#  id                :bigint           not null, primary key
#  deleted           :boolean
#  deleted_at        :datetime
#  identifier        :string
#  order             :integer
#  properties        :jsonb
#  role              :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  breakcold_list_id :bigint
#
# Indexes
#
#  index_breakcold_statuses_on_breakcold_list_id  (breakcold_list_id)
#
# Foreign Keys
#
#  fk_rails_...  (breakcold_list_id => breakcold_lists.id)
#
class Breakcold::Status < Breakcold::BaseRecord
  include Helpers::Parsable
  include ActionView::Helpers::SanitizeHelper

  default_scope { order(order: :asc) }

  belongs_to :list, class_name: 'Breakcold::List', foreign_key: 'breakcold_list_id', inverse_of: :statuses, optional: true

  has_and_belongs_to_many :leads, inverse_of: :statuses, :class_name => 'Breakcold::Lead', :join_table => 'breakcold_leads_statuses', foreign_key: 'breakcold_status_id', association_foreign_key: 'breakcold_lead_id'
  has_and_belongs_to_many :people, :class_name => 'Breakcold::Person', :join_table => 'breakcold_leads_statuses', foreign_key: 'breakcold_status_id', association_foreign_key: 'breakcold_lead_id', scope: -> { Breakcold::Person.all }
  has_and_belongs_to_many :companies, :class_name => 'Breakcold::Company', :join_table => 'breakcold_leads_statuses', foreign_key: 'breakcold_status_id', association_foreign_key: 'breakcold_lead_id', scope: -> { Breakcold::Company.all }


  # {
  #   "color": "#000000",
  #   "created_at": "2025-02-24T12:47:56.969Z",
  #   "icon": null,
  #   "id": "4b32eb86-5c20-4db4-bf9a-3a8f009ab6a7",
  #   "id_list": "db37974f-8e20-4161-a09f-5a57363ee66d",
  #   "id_space": "c6c2ca5c-7fca-49cb-b276-4fa2a9394cf3",
  #   "instructions": null,
  #   "leads_order": null,
  #   "list": {
  #     "table": {
  #       "id": "db37974f-8e20-4161-a09f-5a57363ee66d",
  #       "name": "Sales App (Vuframe) >200 MA",
  #       "emoji": "office"
  #     }
  #   },
  #   "name": "Import",
  #   "order": 0,
  #   "success_rate": null,
  #   "type": null,
  #   "updated_at": "2025-02-24T12:49:04.796Z"
  # }

  def list_id
    properties['id_list']
  end

  def instructions
    strip_tags(properties['instructions'] || '')
  end

  def color
    properties['color']
  end

  def text_color
    return get_foreground_color(color) if color
    '#000000'
  end

  def get_foreground_color(hex)
    # Remove the hash (#) if present
    hex = hex.delete('#')

    # Parse the hex color into RGB components
    r = hex[0..1].to_i(16)
    g = hex[2..3].to_i(16)
    b = hex[4..5].to_i(16)

    # Calculate the relative luminance
    luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255

    # Return black or white based on luminance
    luminance > 0.5 ? '#000000' : '#FFFFFF'
  end

  def parse
    self.properties = normalize_properties
    self.deleted = !properties['deleted_at'].blank?
    self.deleted_at = DateTime.parse(properties['deleted_at']) if properties['deleted_at']
    self.order = properties['order']

    parse_created_at
    parse_updated_at

    self.list = Breakcold::List.find_by(identifier: list_id) if list_id
  end
end
