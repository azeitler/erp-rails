class Avo::Filters::PipedriveFieldTypeFilter < Avo::Filters::BooleanFilter
  self.name = 'Type'

  def apply(request, query, value)
    if value.present?
      field_type = value.select{|k,v| v}&.first&.first.to_s
      if field_type.present?
        query = query.where(field_type: field_type)
      end
    end
    query
  end

  def options
    PipedriveCrm::Field.pluck(:field_type).uniq.sort_by(&:to_s).each_with_object({}) { |field_type, options| options[field_type] = "#{field_type || 'None'} (#{PipedriveCrm::Field.where(field_type:field_type).count})" }
  end
end
