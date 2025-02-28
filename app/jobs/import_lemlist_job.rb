class ImportLemlistJob < ApplicationJob
  queue_as :default

  def perform(*args)
    LemlistClient.new.import_all
  end
end
