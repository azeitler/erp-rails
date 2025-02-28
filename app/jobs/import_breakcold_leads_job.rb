class ImportBreakcoldLeadsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    BreakcoldClient.new.import_leads
  end
end
