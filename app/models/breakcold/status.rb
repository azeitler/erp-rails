class Breakcold::Status < ApplicationRecord
  include Helpers::Parsable

  def parse
    self.deleted = !properties['deleted_at'].blank?
    self.deleted_at = DateTime.parse(properties['deleted_at']) if properties['deleted_at']

  end
end
