# == Schema Information
#
# Table name: pipedrive_people
#
#  id         :bigint           not null, primary key
#  email      :string
#  identifier :string
#  issues     :text
#  labels     :string
#  properties :jsonb
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PipedriveCrm::Person < ApplicationRecord
  include Helpers::Parsable
  include Helpers::ObjectWithIssues

  def emails
    return [] if self.properties.blank?
    return [] unless self.properties['email'].present?
    return [] unless self.properties['email'].select{ |dict| !dict['value'].blank? }.any?
    _emails = self.properties['email'].reject{ |dict| dict['value'].blank? }.map{ |dict| dict['value'].downcase.gsub("mailto:", "") }
    _emails
  end

  def email_count
    emails&.count || 0
  end

  def parse_custom_fields
    hash = {}
    _custom_fields = PipedriveCrm::Field.where(field_target: 'person', field_level: 'custom').select(&:user_generated?)
    _custom_fields.each do |field|
      unless field.system?
        value = self.custom_fields[field.field_name]
        # puts "field.field_name is #{field.field_name} -> #{value || 'null'}"
        if value.present?
          _type = field.field_type
          _value = value
          hash[field.title] = _value

          if _value.is_a?(Hash)
            if _type == "set"
              _value = _value["values"].map{ |val| val.is_a?(Hash) ? val["id"] : val }
            elsif _type == "enum"
              _value = _value["id"]
            else
              _value = _value["value"]
            end
          end

          if _type == "set"
            if _value.is_a?(String)
              _value = field.get_value_for_id(_value)
            else
              _value = _value.map{ |val| field.get_value_for_id(val) }
            end
          elsif _type == "enum"
            _value = field.get_value_for_id(_value)
          end

          hash[field.title] = _value
        end
      end
    end
    hash
  end

  def custom_fields
    self.properties['custom_fields'] || self.properties || {}
  end

  def custom_field_values
    self.properties['custom_field_values']
  end

  def label_field
    @label_field ||= PipedriveCrm::Field.find_by_field_name('label_ids')
  end

  def label_names
    label_ids.map { |lid| label_field.get_value_for_id(lid) }
  end

  def label_ids
    label_ids = self.custom_fields['label_ids'] || []
    label_id = self.custom_fields['label_id']
    label_ids << label_id if label_id.present?
    return label_ids.uniq
  end

  def labels
    super&.split("|") || []
  end

  def parse
    self.email = emails&.detect{ |email| email['primary'] } || emails&.first
    self.properties['custom_field_values'] = self.parse_custom_fields
    self.labels = label_names.join("|")
  end
end
