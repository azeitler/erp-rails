class Lemlist::Lead < ApplicationRecord
  include Helpers::Parsable

  def parse
    self.email = properties['email']
  end
end
