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
class Breakcold::Lead < Breakcold::BaseRecord
  include Helpers::Parsable

  default_scope { where(deleted: false).order(updated_at: :desc) }

  has_and_belongs_to_many :lists, inverse_of: :leads, :class_name => 'Breakcold::List', :join_table => 'breakcold_leads_lists', foreign_key: 'breakcold_lead_id', association_foreign_key: 'breakcold_list_id'
  has_and_belongs_to_many :statuses, inverse_of: :leads, :class_name => 'Breakcold::Status', :join_table => 'breakcold_leads_statuses', foreign_key: 'breakcold_lead_id', association_foreign_key: 'breakcold_status_id'

  has_many :activities, class_name: 'Breakcold::LeadActivity', foreign_key: 'breakcold_lead_id', dependent: :destroy, inverse_of: :lead

  def to_s
    "[#{self.class.name} #{title} (#{identifier})]"
  end

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

  def statuses
    properties['status']
  end

  def statuses_by_list
    properties['status']&.map do |status|
      [ status['id_list'], status['name'] ]
    end.to_h
  end

  def statuses
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
    statuses&.join("\n")
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

  def did_change_status_in_list(list,from,to)
    puts "⭐️⭐️⭐️ Lead #{title} (#{identifier}) changed status in list #{list} from #{from} to #{to}"

  end

  def parse
    self.properties = normalize_properties
    self.email = properties['email']
    self.linkedin_url = properties['linkedin_url']

    # old_statuses = self.status
    # new_statuses = statuses_by_list
    #
    # new_statuses.each do |list_id, new_status|
    #   old_status = old_statuses[list_id]
    #   if !old_status.blank? && old_status != new_status
    #     did_change_status_in_list(list_id, old_status, new_status)
    #   end
    # end
    # self.status = new_statuses

    self.deleted = properties['is_deleted']
    self.deleted_at = DateTime.parse(properties['is_deleted_at']) if properties['is_deleted_at']

    if is_company
      self.title = (properties['company'] || "")
    else
      self.title = ((properties['first_name'] || "") + " " + (properties['last_name'] || "")).strip
    end

    self.lists = Breakcold::List.where(identifier: list_ids)
    self.statuses = Breakcold::Status.where(identifier: status_ids)

    parse_created_at
    parse_updated_at

    true
  end
end
