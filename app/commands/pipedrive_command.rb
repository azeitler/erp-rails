# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

# a command to be executed on an pipedrive entity directly
class PipedriveCommand < PayloadCommand

  attr_reader :id

  def client
    @client ||= PipedriveClient.new
  end

  # @param [Hash] payload: data of the pipedrive object (not wrapped into other fields)
  def initialize(data)
    super(data)
    @id = data['id'] unless data['id'].blank?
  end

  def to_s
    "[#{self.class.name} #{entity} id=#{id}]"
  end
end
