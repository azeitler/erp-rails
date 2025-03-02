# app/models/event.rb
class Event < ApplicationRecord
  # This is a read-only model that maps to the event_store_events table
  self.table_name = 'event_store_events'

  # Make it read-only to prevent accidental modifications
  def readonly?
    true
  end
end
