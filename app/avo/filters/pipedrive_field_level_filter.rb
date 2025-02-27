class Avo::Filters::PipedriveFieldLevelFilter < Avo::Filters::SelectFilter
  self.name = 'Level'

  def apply(request, query, value)
    if value.present?
      field_level = value
      if field_level.present?
        query = query.where(field_level: field_level)
      end
    end
    query
  end

  def options
    PipedriveCrm::Field.pluck(:field_level).uniq.sort_by(&:to_s).each_with_object({}) { |field_level, options| options[field_level] = "#{field_level || 'None'} (#{PipedriveCrm::Field.where(field_level:field_level).count})" }
  end
end
