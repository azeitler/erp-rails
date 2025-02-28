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

  def parse
    self.email = emails&.first
  end
end
