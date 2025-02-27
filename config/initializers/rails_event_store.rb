# config/initializers/rails_event_store.rb
Rails.configuration.to_prepare do
  event_store = RailsEventStore::JSONClient.new
  Rails.configuration.event_store = event_store

  # add subscribers here
  event_store.subscribe(LinkedinInviteAcceptedCommand.new, to: [LinkedinInviteAcceptedEvent])
  # Rails.configuration.event_store.subscribe(ChangeEcoModeCommand.new, to: [Admin::StudioEcoModeChangedEvent])
end
