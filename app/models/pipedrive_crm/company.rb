# == Schema Information
#
# Table name: pipedrive_companies
#
#  id              :bigint           not null, primary key
#  customer_number :string
#  identifier      :string
#  issues          :text
#  properties      :jsonb
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class PipedriveCrm::Company < ApplicationRecord
  include Helpers::Parsable
  include Helpers::ObjectWithIssues

  def parse

  end
end
