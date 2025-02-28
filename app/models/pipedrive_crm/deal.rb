# == Schema Information
#
# Table name: pipedrive_deals
#
#  id         :bigint           not null, primary key
#  close_date :datetime
#  identifier :string
#  issues     :text
#  pipeline   :string
#  properties :jsonb
#  status     :string
#  title      :string
#  value      :decimal(, )
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PipedriveCrm::Deal < ApplicationRecord
  include Helpers::Parsable
  include Helpers::ObjectWithIssues

  def parse

  end
end
