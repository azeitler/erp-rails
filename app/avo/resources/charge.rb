class Avo::Resources::Charge < Avo::BaseResource
  self.title = :processor_id
  self.includes = []
  self.model_class = Pay::Charge
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], processor_id_cont: params[:q], m: "or").result(distinct: false)},
    item: -> {
      {
        title: record.processor_id
      }
    }
  }

  def fields
    field :id, as: :id
    field :customer, as: :belongs_to
    field :amount, as: :text
    field :amount_refunded, as: :text
    field :created_at, as: :date_time

    with_options only_on: :show do
      field :processor_id, as: :text, format_using: -> do
        link_to value, view_context.controller.charge_processor_url(model), target: :_blank
      rescue
        value
      end
      field :subscription, as: :belongs_to
      field :updated_at, as: :date_time
    end
  end
end
