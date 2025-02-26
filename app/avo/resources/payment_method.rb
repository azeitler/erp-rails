class Avo::Resources::PaymentMethod < Avo::BaseResource
  self.includes = []
  self.model_class = Pay::PaymentMethod
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], processor_id_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.id,
      }
    }
  }

  def fields
    main_panel do
      field :id, as: :id
      field :customer, as: :belongs_to
      field :processor_id, as: :text
      field :type, as: :text
      field :default, as: :boolean
      field :data, as: :key_value

      sidebar do
        field :extra_billing_info, as: :key_value
        field :created_at, as: :date_time
        field :updated_at, as: :date_time
      end
    end
  end
end
