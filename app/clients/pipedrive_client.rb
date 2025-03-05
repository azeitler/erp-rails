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

  def write_file(path, data)
    File.open(path, 'w') do |file|
      file.write(data)
    end
    puts "Wrote file to #{path}"
  end

  def import_persons
    log "importing persons..."
    updated = 0
    imported = 0
    with_timer do
      _persons = persons
      log "saving #{_persons.count} persons..."
      tmp_file = Rails.root.join('tmp', 'pipedrive_persons.json')
      write_file(tmp_file, JSON.pretty_generate(_persons.map(&:to_h)))
      log "saving #{_persons.count} persons... #{::ApplicationController.helpers.number_to_human_size(File.size(tmp_file))}"
      log "importing #{_persons.count} persons..."
      count = 0
      _persons.each do |person|
        res = import_person(person)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
        count += 1
        if count % 1000 == 0
          log "imported #{count} persons..."
        end
      end
      log "checking for deleted persons..."
      deleted = prune_model(_persons.map { |obj| obj['id'].to_s }, PipedriveCrm::Person)
      log "imported #{imported} persons, updated #{updated}, deleted #{deleted} persons out of #{_persons.count} persons"
      PipedriveCrm::Person.parse_all_and_save
    end
    true
  end

  def import_person(person)
    unless person.is_a?(Pipedrive::Person) || person.is_a?(Hash)
      log "needs to be a Pipedrive::Person or Hash" and return
    end
    person_id = person['id'].to_s
    pipedrive_person, result = import_model_with_id(PipedriveCrm::Person, person_id) do |pipedrive_person|
      pipedrive_person.properties = person.to_h
      pipedrive_person.title = person['name']
    end
    pipedrive_person.parse_and_save
    result
  end

  def persons
    @persons ||= begin
                   persons = with_timer do
                     persons = Pipedrive::Person.all(nil, { :query => {} }, true) do |additional_data|
                       log "getting persons: #{additional_data['pagination']['next_start']}"
                     end
                     log "got #{persons.count} persons"
                     persons
                   end
                   persons
                 end
  end

  def fields
    @fields ||= begin
                  Pipedrive::DealField.all(nil, { :query => {} }, true) +
                  Pipedrive::PersonField.all(nil, { :query => {} }, true) +
                  Pipedrive::OrganizationField.all(nil, { :query => {} }, true) +
                  Pipedrive::ProductField.all(nil, { :query => {} }, true)
                end
  end

  def users
    @users ||= begin
                 Pipedrive::User.all(nil, { :query => {} }, true) # .select { |e| e.active_flag }
               end
  end

  def import_fields
    log "importing fields..."
    updated = 0
    imported = 0
    with_timer do
      fields.each do |field|
        res = import_field(field)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
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
    pipedrive_field.parse_and_save
    result
  end

  def import_users
    log "importing users..."
    updated = 0
    imported = 0
    _users = users
    with_timer do
      _users.each do |user|
        res = import_user(user)
        updated += 1 if res == :updated
        imported += 1 if res == :imported
      end
      deleted = prune_model(_users.map { |user| user['id'].to_s }, PipedriveCrm::User)
      PipedriveCrm::User.parse_all_and_save
      log "imported #{imported} users, updated #{updated}, deleted #{deleted} users out of #{_users.count} users"
    end
  end

  def import_user(user)
    unless user.is_a?(Pipedrive::User) || user.is_a?(Hash)
      log "needs to be a Pipedrive::User or Hash" and return
    end
    user_id = user['id'].to_s
    pipedrive_user, result = import_model_with_id(PipedriveCrm::User, user_id) do |pipedrive_user|
      pipedrive_user.properties = user.to_h
      pipedrive_user.title = user['name']
    end
    pipedrive_user.parse_and_save
    result
  end

end
