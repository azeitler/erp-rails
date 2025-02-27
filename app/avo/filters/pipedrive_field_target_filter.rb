class Avo::Filters::PipedriveFieldTargetFilter < Avo::Filters::BooleanFilter
  self.name = 'Target'

  def apply(request, query, value)
    if value.present?
      field_target = value.select{|k,v| v}&.first&.first.to_s
      if field_target.present?
        query = query.where(field_target: field_target)
      end
    end
    query
  end

  def options
    PipedriveCrm::Field.pluck(:field_target).uniq.sort_by(&:to_s).each_with_object({}) { |field_target, options| options[field_target] = "#{field_target || 'None'} (#{PipedriveCrm::Field.where(field_target:field_target).count})" }
  end
end
