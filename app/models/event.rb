# == Schema Information
#
# Table name: event_store_events
#
#  id         :bigint           not null, primary key
#  data       :jsonb            not null
#  event_type :string           not null
#  metadata   :jsonb
#  valid_at   :datetime
#  created_at :datetime         not null
#  event_id   :uuid             not null
#
# Indexes
#
#  index_event_store_events_on_created_at  (created_at)
#  index_event_store_events_on_event_id    (event_id) UNIQUE
#  index_event_store_events_on_event_type  (event_type)
#  index_event_store_events_on_valid_at    (valid_at)
#
# app/models/event.rb
class Event < ApplicationRecord
  # This is a read-only model that maps to the event_store_events table
  self.table_name = 'event_store_events'

  def data
    HashWithIndifferentAccess.new(super)
  end

  # Make it read-only to prevent accidental modifications
  def readonly?
    true
  end
end
