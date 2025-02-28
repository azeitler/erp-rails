class Avo::Actions::ImportBreakcoldLists < Avo::BaseAction
  self.name = "Import Breakcold Lists"
  self.standalone = true
  self.visible = -> { view == :index }
  self.no_confirmation = true

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    ImportBreakcoldListsJob.perform_later
  end
end
