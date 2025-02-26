class Avo::Resources::Account < Avo::BaseResource
  self.title = :name
  self.includes = [:owner, :users]
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.name,
        image_url: record.avatar
      }
    }
  }

  def fields
    main_panel do
      field :id, as: :id
      field :avatar,
        as: :file,
        is_image: true,
        link_to_resource: true,
        rounded: true,
        hide_on: :forms
      field :owner, as: :belongs_to
      field :name, as: :text
      field :personal, as: :boolean
      field :users_count, as: :text do
        record.users.length
      end

      sidebar do
        field :extra_billing_info, as: :textarea
        field :created_at, as: :date_time
        field :updated_at, as: :date_time
      end
    end

    tabs do
      field :subscriptions, as: :has_many
      field :pay_customers, as: :has_many
      field :charges, as: :has_many
      field :account_users, as: :has_many
      field :users, as: :has_many
    end
  end
end
