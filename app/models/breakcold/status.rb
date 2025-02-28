# == Schema Information
#
# Table name: breakcold_statuses
#
#  id         :bigint           not null, primary key
#  deleted    :boolean
#  deleted_at :datetime
#  identifier :string
#  properties :jsonb
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Breakcold::Status < ApplicationRecord
  include Helpers::Parsable

  def parse
    self.deleted = !properties['deleted_at'].blank?
    self.deleted_at = DateTime.parse(properties['deleted_at']) if properties['deleted_at']

  end
end
