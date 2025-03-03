class Avo::Actions::ImportPipedriveUsers < Avo::BaseAction
  self.name = "Import Pipedrive Users"
  self.standalone = true
  self.visible = -> { view == :index }
  self.no_confirmation = true

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    ImportPipedriveUsersJob.perform_later
  end
end
