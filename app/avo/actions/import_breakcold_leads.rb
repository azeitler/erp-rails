class Avo::Actions::ImportBreakcoldLeads < Avo::BaseAction
  self.name = "Import Breakcold Leads"
  self.standalone = true
  self.visible = -> { view == :index }
  self.no_confirmation = true

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    ImportBreakcoldLeadsJob.perform_later
  end
end
