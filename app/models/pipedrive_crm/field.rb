# == Schema Information
#
# Table name: pipedrive_fields
#
#  id           :bigint           not null, primary key
#  field_level  :string
#  field_name   :string
#  field_target :string
#  field_type   :string
#  identifier   :string
#  issues       :text
#  properties   :jsonb
#  title        :string
#  values       :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class PipedriveCrm::Field < ApplicationRecord
  include Helpers::Parsable
  include Helpers::ObjectWithIssues

  default_scope { order('title ASC') }
  def parse
    clear_issues
    self.title = self.properties['name']
    self.field_name = properties['key']
    self.field_type = properties['field_type']
    self.field_level = system? ? 'system' : 'custom'
    self.field_target = self.identifier.split("_").first
    # self.user_id = self.last_updated_by_user_id

    if self.field_name.ends_with?("_currency")
      base_field_key = field_name.gsub("_currency", "")
      base_field = PipedriveCrm::Field.find_by_field_name(base_field_key)
      if base_field
        properties['last_updated_by_user_id'] = base_field.properties['last_updated_by_user_id']
      end
    end

    # self.title = self.properties['name']
    parse_created_at('add_time')
    self.values ||= []
    if should_pluck_values?
      self.values = pluck_values
    end

    true
  end

  def target_klass
    case field_target
      when 'deal'
        return PipedriveCrm::Deal
      when 'person'
        return PipedriveCrm::Person
      when 'organization'
        return PipedriveCrm::Company
      # when 'product'
      #   return PipedriveProduct
    end

    nil
  end

  def should_pluck_values?
    return false if system_level?
    true
  end

  def pluck_values
    return unless target_klass
    puts "#{title}[#{field_target}]: plucking values..."
    values = target_klass.pluck("properties").map{|dict|dict[field_name]}.uniq.compact
    if field_type == "enum"
      values = values.map{ |val| (options.detect{|option| option['id']&.to_s == val } || {})['label'] }
    end
    values
  end

  def edit_flag
    properties['edit_flag']
  end

  def active_flag
    properties['active_flag']
  end

  def pipedrive_id
    properties['id']
  end

  def options
    properties['options']
  end

  def get_id_for_option(label)
    options.detect{|opt| opt['label'] == label }&.dig('id')
  end

  def last_updated_by_user_id
    properties['last_updated_by_user_id']
  end

  def system?
    k = 'last_updated_by_user_id'
    return false if field_name&.length == 40
    return true if ['label','lost_reason','category'].include?(field_name)
    # return false if properties.key?(k)
    properties[k].blank?
    # edit_flag
  end

  def system_level?
    self.field_level == 'system'
  end

  def field_options
    properties['options']&.map{ |opt| opt['label'] }&.join("\n")
  end

end
