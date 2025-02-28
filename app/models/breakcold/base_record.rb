# Project: erp-rails
# Created Date: 2025-02-28
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class Breakcold::BaseRecord < ApplicationRecord
  self.abstract_class = true

  def normalize_properties
    normalize_hash(self.properties)
  end
  def normalize_hash(properties)
    # "lists": [
    #   {
    #     "table": {
    #       "id": "db37974f-8e20-4161-a09f-5a57363ee66d",
    #       "name": "Sales App (Vuframe) >200 MA",
    #       "emoji": "office",
    #       "order": 9
    #     }
    #   }
    # ],
    # the properties hash contains a number of arrays which in turn contain arrays of hashes which might only contain a single key 'table', in this case we want to remove the intermediate hash
    # we want to check any array keys for a hash with a single key 'table' and replace the array with the value of the 'table' key, even nested ones
    properties.each do |key, value|
      if value.is_a?(Array)
        properties[key] = value.map do |item|
          if item.is_a?(Hash) && item.keys.length == 1 && item['table']
            new_value = item['table']
            new_value.is_a?(Hash) ? normalize_hash(new_value) : new_value
          else
            item.is_a?(Hash) ? normalize_hash(item) : item
          end
        end
      end
    end
    properties
  end
end
