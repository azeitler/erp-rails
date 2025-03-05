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
class Breakcold::Lead < Breakcold::BaseRecord
  include Helpers::Parsable

  default_scope { where(deleted: false).order(updated_at: :desc) }

  has_and_belongs_to_many :lists, inverse_of: :leads, :class_name => 'Breakcold::List', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_lead_id', association_foreign_key: 'breakcold_list_id'
  has_and_belongs_to_many :statuses, inverse_of: :leads, :class_name => 'Breakcold::Status', :join_table => 'breakcold_leads_statuses', foreign_key: 'breakcold_lead_id', association_foreign_key: 'breakcold_status_id'

  has_many :activities, class_name: 'Breakcold::LeadActivity', foreign_key: 'breakcold_lead_id', dependent: :destroy, inverse_of: :lead

  has_and_belongs_to_many :lemlist_leads, :class_name => 'Lemlist::Lead', join_table: 'breakcold_leads_lemlist_leads', foreign_key: 'breakcold_lead_id', association_foreign_key: 'lemlist_lead_id', inverse_of: :breakcold_leads

  def to_s
    "[#{self.class.name} #{title} (#{identifier})]"
  end

  def is_company
    self.properties['is_company']
  end

  def company_name
    properties['company']
  end

  def first_name
    properties['first_name']
  end

  def last_name
    properties['last_name']
  end

  def company_position
    properties['company_role']
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

  def status_definitions
    properties['status']
  end

  def statuses_by_list
    properties['status']&.map do |status|
      [ status['id_list'], status['name'] ]
    end.to_h
  end

  def language_tag
    return "Deutsch" if tags.detect { |tag| tag.downcase.include?("deutsch") }
    return "Englisch" if tags.detect { |tag| tag.downcase.include?("englis") }
  end

  def statuses_descriptions
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
    statuses_descriptions&.join("\n")
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

  def status_ids
    properties['status']&.map do |status|
      status['id']
    end
  end

  def status_for_list(list_id)
    properties['status']&.find do |status|
      status['id_list'] == list_id
    end
  end

  def did_change_status_in_list(list,from,to)
    puts "⭐️⭐️⭐️ Lead #{title} (#{identifier}) changed status in list #{list} from #{from} to #{to}"

  end

  def parse
    self.properties = normalize_properties
    self.email = properties['email']
    self.linkedin_url = properties['linkedin_url']

    self.status = statuses_by_list

    self.deleted = properties['is_deleted']
    self.deleted_at = DateTime.parse(properties['is_deleted_at']) if properties['is_deleted_at']

    if is_company
      self.title = (properties['company'] || "")
    else
      self.title = ((properties['first_name'] || "") + " " + (properties['last_name'] || "")).strip
    end

    self.lists = Breakcold::List.where(identifier: list_ids)
    self.statuses = Breakcold::Status.where(identifier: status_ids)
    self.language = self.language_tag

    parse_created_at
    parse_updated_at

    true
  end
end
