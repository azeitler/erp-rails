class Avo::Actions::ImportPipedriveFields < Avo::BaseAction
  self.name = "Import Pipedrive Fields"
  self.standalone = true
  self.visible = -> { view == :index }
  self.no_confirmation = true

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    ImportPipedriveFieldsJob.perform_later
  end
end
