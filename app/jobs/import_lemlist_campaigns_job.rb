class ImportLemlistCampaignsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    LemlistClient.new.import_campaigns
  end
end
