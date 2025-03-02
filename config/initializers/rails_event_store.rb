# config/initializers/rails_event_store.rb
Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::JSONClient.new

  # add subscribers here
  Rails.configuration.event_store.subscribe(LinkEventToStreamCommand.new('lemlist'), to: [LinkedinInviteAcceptedEvent, LinkedinInviteSentEvent, AddLeadToLemlistCampaignCommand])
  Rails.configuration.event_store.subscribe(LinkedinInviteAcceptedCommand.new, to: [LinkedinInviteAcceptedEvent])
  Rails.configuration.event_store.subscribe(LinkedinInviteSentCommand.new, to: [LinkedinInviteSentEvent])

  Rails.configuration.event_store.subscribe(AddLeadToLemlistCampaignCommand.new, to: [BreakcoldStatusUpdateEvent])

  # Rails.configuration.event_store.subscribe(to: [LinkedinInviteAcceptedEvent]) do |event|
  #   Rails.logger.info "🚨🚨🚨 LinkedinInviteAcceptedEvent: #{event.inspect}"
  # end

  # puts "🚨🚨🚨 Rails.configuration.event_store: #{Rails.configuration.event_store.inspect}"
  # puts LinkEventToStreamCommand.new('lemlist').inspect

  # Rails.configuration.event_store.subscribe(ChangeEcoModeCommand.new, to: [Admin::StudioEcoModeChangedEvent])

end
