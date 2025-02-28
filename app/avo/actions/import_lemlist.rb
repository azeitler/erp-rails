class Avo::Actions::ImportLemlist < Avo::BaseAction
  self.name = "Import Lemlist (everything)"
  self.standalone = true
  self.visible = -> { view == :index }

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    ImportLemlistJob.perform_later
  end
end
