class Avo::Resources::LemlistLead < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Lemlist::Lead
  self.authorization_policy = ViewOnlyPolicy
  self.title = :title
  self.search = {
    query: -> { query.ransack(title_i_cont: params[:q], m: "or").result(distinct: false) },
    item: -> do
      {
        title: "#{record.title} [#{record.identifier}]",
        description: record.description
      }
    end
  }

  def fields
    # field :id, as: :id
    # field :identifier, as: :text
    field :avatar, as: :external_image do
      record.avatar_url
    end
    field :title, as: :text, link_to_record: true
    field :campaign, as: :belongs_to
    field :email, as: :text
    field 'LinkedIn',
      as: :badge,
      options: {
        success: :profile,
        warning: :salesnav,
        neutral: :missing
      } do
      record.linkedin_type
    end
    field :company, as: :text
    field :language, as: :text, readonly: true
    field :updated_at, as: :date_time, readonly: true

    field 'LinkedIn Url', as: :text, hide_on: [:index] do
      record.linkedin_url
    end

    field :lemlist_leads, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldLead, reloadable: true

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ImportLemlist
  end

  def filters
    filter Avo::Filters::LemlistCampaignFilter
  end
end
