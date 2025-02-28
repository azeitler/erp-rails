# == Schema Information
#
# Table name: breakcold_tags
#
#  id         :bigint           not null, primary key
#  identifier :string
#  properties :jsonb
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Breakcold::Tag < Breakcold::BaseRecord
  include Helpers::Parsable

  def parse
    self.deleted = !properties['deleted_at'].blank?
    self.deleted_at = DateTime.parse(properties['deleted_at']) if properties['deleted_at']

  end
end
