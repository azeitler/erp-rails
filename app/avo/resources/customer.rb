class Avo::Resources::Customer < Avo::BaseResource
  self.title = :name
  self.includes = [:owner]
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], processor_id_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.name,
      }
    }
  }
  self.model_class = Pay::Customer

  def fields
    main_panel do
      field :id, as: :id
      field :owner, as: :belongs_to, polymorphic_as: :owner, types: [::Account]

      field :processor, as: :badge, options: {success: "stripe"}
      field :processor_id, as: :text, format_using: -> do
        link_to(value, view_context.controller.customer_processor_url(model), target: :_blank)
      rescue
        value
      end
      field :default, as: :boolean
      field :data, as: :key_value

      sidebar do
        field :created_at, as: :date_time
        field :updated_at, as: :date_time
        field :deleted_at, as: :date_time
      end
    end

    tabs do
      field :subscriptions, as: :has_many
      field :charges, as: :has_many
    end
  end
end
