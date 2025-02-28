class ImportBreakcoldListsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    BreakcoldClient.new.import_lists
    BreakcoldClient.new.import_all_statuses
  end
end
