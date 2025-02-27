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
