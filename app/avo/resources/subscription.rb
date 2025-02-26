class Avo::Resources::Subscription < Avo::BaseResource
  self.title = :processor_id
  self.includes = [:owner, :customer]
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], processor_id_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.processor_id,
      }
    }
  }
  self.model_class = Pay::Subscription

  def fields
    main_panel do
      field :id, as: :id
      with_options only_on: :index do
        field :customer, as: :belongs_to
        field :name, as: :text
        field :active?, as: :boolean, name: "Active"
        field :cancelled?, as: :boolean, name: "Cancelled"
      end
      field :owner, as: :has_one
      field :processor_id, as: :text, format_using: ->(id) do
        link_to id, view_context.controller.subscription_processor_url(model), target: :_blank
      rescue
        id
      end
      field :active?, as: :boolean
      field :processor, as: :badge, options: {success: "Stripe"} do |model, *args|
        name = record.payment_processor.class.to_s.split("::").second
        if name.downcase.include? "fake"
          "Fake"
        else
          name
        end
      rescue
        "Unknown"
      end

      sidebar do
        field :status, as: :status, readonly: true, failed_when: [:canceled], loading_when: [:trialing]
        field :trial_ends_at_ago, as: :text
        field :created_at, as: :date_time, readonly: true
        field :ends_at, as: :date_time, readonly: true
        field :processor_id, as: :text, readonly: true, as_html: true do
          case record.customer.processor
          when "stripe"
            link_to(record.processor_id, "https://dashboard.stripe.com/subscriptions/#{record.processor_id}", target: :_blank)
          else
            record.processor_id
          end
        end
        field :processor_plan, as: :text, readonly: true
        field :quantity, as: :number, readonly: true
      end
    end
  end
end
