# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

# a command to be executed on an breakcold entity directly
class BreakcoldCommand < PayloadCommand

  attr_reader :payload

  def client
    @client ||= BreakcoldClient.new
  end

  # @param [Hash] payload: data of the pipedrive object (not wrapped into other fields)
  def initialize(payload)
    super(payload)
    @id = payload['id'] unless payload['id'].blank?
  end

  def to_s
    "[#{self.class.name} #{entity} id=#{id}]"
  end
end
