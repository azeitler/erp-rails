class Breakcold::Lead < ApplicationRecord
  include Helpers::Parsable

  default_scope { where(deleted: false).order(updated_at: :desc) }

  has_and_belongs_to_many :lists, inverse_of: :leads, :class_name => 'Breakcold::List', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_lead_id', association_foreign_key: 'breakcold_list_id'
  has_many :activities, class_name: 'Breakcold::LeadActivity', foreign_key: 'breakcold_lead_id', dependent: :destroy, inverse_of: :lead

  def is_company
    self.properties['is_company']
  end

  def tags
    properties['tags']&.map do |tag|
      if tag['name']
        tag['name']
      elsif tag['table']
        tag['table']['name']
      end
    end
  end

  def status
    @status ||= begin
                  unless properties['status'].blank?
                    _status = properties['status']
                    _status.map do |status|
                      if status['table'].blank?
                        status_name = status['name']
                        status_list_id = status['id_list']
                      else
                        status_name = status['table']['name']
                        status_list_id = status['table']['id_list']
                      end
                      status_list = lists.find { |list| list.identifier == status_list_id }
                      if status_list
                        "#{status_list.title} -> #{status_name}"
                      else
                        "<unknown list> -> #{status_name}"
                      end
                    end
                  end
                end
  end

  def status_text
    status&.join("\n")
  end

  def avatar_url
    properties['avatar_url']
  end

  def list_ids
    properties['lists']&.map do |list|
      if list['id']
        list['id']
      elsif list['table']
        list['table']['id']
      end
    end
  end

  def parse
    self.properties = normalize_properties
    self.email = properties['email']

    self.deleted = properties['is_deleted']
    self.deleted_at = DateTime.parse(properties['is_deleted_at']) if properties['is_deleted_at']

    if is_company
      self.title = (properties['company'] || "")
    else
      self.title = ((properties['first_name'] || "") + " " + (properties['last_name'] || "")).strip
    end

    self.lists = Breakcold::List.where(identifier: list_ids)

    parse_created_at
    parse_updated_at

    true
  end

  def normalize_properties
    normalize_hash(self.properties)
  end
  def normalize_hash(properties)
    # "lists": [
    #   {
    #     "table": {
    #       "id": "db37974f-8e20-4161-a09f-5a57363ee66d",
    #       "name": "Sales App (Vuframe) >200 MA",
    #       "emoji": "office",
    #       "order": 9
    #     }
    #   }
    # ],
    # the properties hash contains a number of arrays which in turn contain arrays of hashes which might only contain a single key 'table', in this case we want to remove the intermediate hash
    # we want to check any array keys for a hash with a single key 'table' and replace the array with the value of the 'table' key, even nested ones
    properties.each do |key, value|
      if value.is_a?(Array)
        properties[key] = value.map do |item|
          if item.is_a?(Hash) && item.keys.length == 1 && item['table']
            new_value = item['table']
            new_value.is_a?(Hash) ? normalize_hash(new_value) : new_value
          else
            item.is_a?(Hash) ? normalize_hash(item) : item
          end
        end
      end
    end
    properties
  end
end
