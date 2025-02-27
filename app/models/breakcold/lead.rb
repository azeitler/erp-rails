class Breakcold::Lead < ApplicationRecord
  include Helpers::Parsable

  def is_company
    self.properties['is_company']
  end

  def parse
    self.email = properties['email']

    if is_company
      self.title = (properties['company'] || "")
    else
      self.title = ((properties['first_name'] || "") + " " + (properties['last_name'] || "")).strip
    end
  end
end
