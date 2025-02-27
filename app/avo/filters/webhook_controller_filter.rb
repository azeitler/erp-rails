class Avo::Filters::WebhookControllerFilter < Avo::Filters::SelectFilter
  self.name = "Controller"

  def apply(request, query, value)
    if value.present?
      controller = value
      if controller.present?
        query = query.where(controller_name: controller)
      end
    end
    query
  end

  def options
    InboundWebhook.pluck(:controller_name).uniq.sort_by(&:to_s).each_with_object({}) { |controller, options| options[controller] = "#{controller || 'None'} (#{InboundWebhook.where(controller_name:controller).count})" }
  end
end
