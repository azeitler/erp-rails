# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class PipedriveClient < ImportClient

  def initialize(auth: nil, basic_auth: nil, token: nil)
    Pipedrive.authenticate(Rails.application.credentials.dig(:pipedrive, :token))
  end


  def fields
    @fields ||= begin
                  Pipedrive::DealField.all(nil, { :query => {} }, true) +
                  Pipedrive::PersonField.all(nil, { :query => {} }, true) +
                  Pipedrive::OrganizationField.all(nil, { :query => {} }, true) +
                  Pipedrive::ProductField.all(nil, { :query => {} }, true)
                end
  end

  def import_fields
    log "importing fields..."
    updated = 0
    imported = 0
    with_timer do
      fields.each do |field|
        res = import_field(field)
        updated += 1 if res == 1
        imported += 1 if res == 2
      end
      deleted = prune_model(fields.map { |field|
        field_type = field.class.name.gsub("Pipedrive::", "").gsub("Field", "").downcase
        field_type + "_" + field['id'].to_s
      }, PipedriveCrm::Field)
      PipedriveCrm::Field.parse_all_and_save
      log "imported #{imported} fields, updated #{updated}, deleted #{deleted} fields out of #{fields.count} fields"
    end
  end

  def import_field(field)
    unless field.is_a?(Pipedrive::DealField) or field.is_a?(Pipedrive::PersonField) or field.is_a?(Pipedrive::OrganizationField) or field.is_a?(Pipedrive::ProductField)
      log "needs to be a Pipedrive::Field" and return
    end
    field_type = field.class.name.gsub("Pipedrive::", "").gsub("Field", "").downcase
    field_id = field_type + "_" + field['id'].to_s
    pipedrive_field, result = import_model_with_id(PipedriveCrm::Field, field_id) do |pipedrive_field|
      pipedrive_field.properties = field.to_h
      pipedrive_field.title = field['name']
    end
    result
  end

end
