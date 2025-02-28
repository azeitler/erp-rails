class Avo::Actions::ImportLemlistCampaigns < Avo::BaseAction
  self.name = "Import Lemlist Campaigns"
  self.standalone = true
  self.visible = -> { view == :index }
  self.no_confirmation = true

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    ImportLemlistCampaignsJob.perform_later
  end
end
