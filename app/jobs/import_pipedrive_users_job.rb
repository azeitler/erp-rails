class ImportPipedriveUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PipedriveClient.new.import_users
  end
end
