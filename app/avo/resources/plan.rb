class Avo::Resources::Plan < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], description_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.name,
      }
    }
  }

  def fields
    main_panel do
      field :id, as: :id
      field :name, as: :text
      field :description, as: :text, hide_on: :index
      field :hidden, as: :boolean
      field :amount, as: :number, help: "Price in cents", format_using: -> do
        if view == :edit || view == :new
          value
        else
          (BigDecimal(value.to_s) / 100).round(2)
        end
      end
      field :currency, as: :select, options: Pay::Currency.all.map { |iso, v| ["#{iso.upcase} - #{v["name"]}", iso] }.to_h
      field :interval, as: :select, options: [:month, :year]
      field :interval_count, as: :number
      field :trial_period_days, as: :number

      field :features, as: :tags

      sidebar do
        field :created_at, as: :date_time
        field :updated_at, as: :date_time
        field :processor_details, as: :heading, label: "Processor details"
        field :stripe_id, as: :text, format_using: -> do
          if view == :edit || view == :new
            value
          else
            link_to value, "https://dashboard.stripe.com/plans/#{value}", target: :_blank
          end
        rescue
          value
        end
        field :braintree_id, as: :text, format_using: -> do
          if view == :edit || view == :new
            value
          else
            link_to value, "https://sandbox.braintreegateway.com/merchants/#{Pay::Braintree.merchant_id}/plans/#{id}", target: :_blank
          end
        rescue
          value
        end
        field :paddle_id, as: :text
        field :fake_processor_id, as: :text
      end
    end
  end
end
