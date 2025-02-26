class Avo::Resources::User < Avo::BaseResource
  self.title = :name
  self.includes = [:accounts]
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], email_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.name,
      }
    }
  }

  def fields
    field :id, as: :id
    field :avatar, as: :file, is_image: true, hide_on: :forms, link_to_resource: true
    field :name, as: :text
    field :email, as: :text
    field :admin, as: :boolean, help: "Whether the user has admin capabilities."

    with_options hide_on: :forms do
      field :number_of_accounts, as: :text do
        record.accounts.length
      end
    end

    tabs do
      field :accounts, as: :has_many
      field :connected_accounts, as: :has_many
    end

    tabs do
      tab "General" do
        panel do
          field :time_zone, as: :text
          field :invitations_count, as: :text
        end
      end
      tab "Account management" do
        panel do
          field :password, as: :password
          field :password_confirmation, as: :password
          field :reset_password_token, as: :password
          field :reset_password_sent_at, as: :date_time
          field :remember_created_at, as: :date_time
          field :confirmation_token, as: :text
          field :confirmed_at, as: :date_time
          field :confirmation_sent_at, as: :date_time
          field :unconfirmed_email, as: :text
          field :created_at, as: :date_time
          field :updated_at, as: :date_time
          field :invitation_token, as: :text
          field :invitation_created_at, as: :date_time
          field :invitation_sent_at, as: :date_time
          field :invitation_accepted_at, as: :date_time
          field :invitation_limit, as: :number
          field :terms_of_service, as: :boolean
          field :accepted_terms_at, as: :date_time
          field :accepted_privacy_at, as: :date_time
        end
      end
    end
  end
end
