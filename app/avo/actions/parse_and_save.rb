class Avo::Actions::ParseAndSave < Avo::BaseAction
  self.name = "Re-Parse"
  self.no_confirmation = true

  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.parse_and_save
    end
  end
end
