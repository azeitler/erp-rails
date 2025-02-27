# Project: erp-rails
# Created Date: 2025-02-27
# Author: Andreas Zeitler me@azeitler.com
# -----
# Copyright (c) 2025 Andreas Zeitler
# -----

class ImportClient < ApplicationClient
  def with_timer
    @now = Time.now.to_f
    val = yield
    @endd = Time.now.to_f
    puts "..took #{humanize_duration(@endd - @now)}!"
    val
  end

  def get_import_time
    return humanize_duration(@endd - @now)
  end

  def humanize_duration(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end

  def prune_model(ids,klass)
    ids ||= []
    deletable = klass.where.not(identifier: ids)

    uniq_ids = klass.pluck(:identifier).uniq
    dupl_ids = uniq_ids.select{ |uniq_id| klass.where(identifier: uniq_id).count > 1 }

    dupls = klass.where(identifier: dupl_ids)
    dupls = dupls[1..dupls.count]||[]
    puts "found duplicated entries: #{dupls.map(&:identifier).join("\n")}" if dupls.any?

    deletable = klass.where(id: (deletable + dupls).flatten.uniq.map(&:id))

    deleted = deletable.count
    deletable.destroy_all
    deleted
  end

  def prune_duplicates(klass)
    uniq_ids = klass.pluck(:identifier).uniq
    dupl_ids = uniq_ids.select{ |uniq_id| klass.where(identifier: uniq_id).count > 1 }

    dupls = klass.where(identifier: dupl_ids)
    dupls = dupls[1..dupls.count]||[]
    puts "found duplicated entries: #{dupls.map(&:identifier).join("\n")}" if dupls.any?

    deletable = klass.where(id: dupls.flatten.uniq.map(&:id))

    deleted = deletable.count
    deletable.destroy_all
    deleted
  end

  def import_model_with_id(klass,id)
    entity = klass.find_by(identifier: id)
    entity = klass.new(identifier: id) if entity.nil?
    yield(entity)
    status_code = nil
    if entity.changed? or !entity.persisted?
      status_code = entity.persisted? ? :updated : :imported
      entity.parse_and_save
    end
    return entity, status_code
  end
end
