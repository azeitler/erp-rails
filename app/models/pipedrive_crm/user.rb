# == Schema Information
#
# Table name: pipedrive_users
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
class PipedriveCrm::User < ApplicationRecord
  include Helpers::Parsable
  include Helpers::ObjectWithIssues

  def parse
    self.email = properties['email']
  end

  def to_s
    "#{title} <#{email}>"
  end
end
