class Breakcold::Lead < ApplicationRecord
  include Helpers::Parsable

  default_scope { where(deleted: false) }

  has_and_belongs_to_many :lists, inverse_of: :leads, :class_name => 'Breakcold::List', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_lead_id', association_foreign_key: 'breakcold_list_id'

  def is_company
    self.properties['is_company']
  end

  def tags
    properties['tags']&.map { |tag| tag['table']['name'] }
  end

  def avatar_url
    properties['avatar_url']
  end

  def list_ids
    properties['lists']&.map { |tag| tag['table']['id'] }
  end

  def parse
    self.email = properties['email']

    self.deleted = properties['is_deleted']
    self.deleted_at = DateTime.parse(properties['is_deleted_at']) if properties['is_deleted_at']

    if is_company
      self.title = (properties['company'] || "")
    else
      self.title = ((properties['first_name'] || "") + " " + (properties['last_name'] || "")).strip
    end

    self.lists = Breakcold::List.where(identifier: list_ids)
  end
end
