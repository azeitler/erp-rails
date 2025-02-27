class ImportPipedriveFieldsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PipedriveClient.new.import_fields
  end
end
