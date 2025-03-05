# == Schema Information
#
# Table name: pipedrive_people
#
#  id         :bigint           not null, primary key
#  email      :string
#  identifier :string
#  issues     :text
#  properties :jsonb
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PipedriveCrm::Person < ApplicationRecord
  include Helpers::Parsable
  include Helpers::ObjectWithIssues

  def emails
    return [] unless properties['emails'].select{ |dict| !dict['value'].blank? }.any?
    properties['emails'].reject{ |dict| dict['value'].blank? }.map{ |dict| dict['value'].downcase }
  end

  def email_count
    emails&.count || 0
  end

  def self.custom_fields
    @@custom_fields ||= PipedriveCrm::Field.where(field_target: 'person')
  end

  def parse_custom_fields
    hash = {}
    self.class.custom_fields.each do |field|
      value = self.properties[field.field_name]
      if value.present?
        hash[field.title] = value
      end
    end
    hash
  end

  def custom_fields
    self.properties['custom_fields']
  end

  def parse
    self.email = emails&.first
    self.properties['custom_fields'] = self.parse_custom_fields
  end
end
