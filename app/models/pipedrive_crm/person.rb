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
