module Breakcold
  def self.table_name_prefix
    "breakcold_"
  end

  def self.list_url(list_id)
    "https://app.breakcold.com/pipeline" # "/#{list_id}"
  end
end
