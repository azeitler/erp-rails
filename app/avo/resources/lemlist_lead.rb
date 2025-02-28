class Avo::Resources::LemlistLead < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Lemlist::Lead
  self.authorization_policy = ViewOnlyPolicy
  self.title = :title
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

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

    field 'LinkedIn Url', as: :text, hide_on: [:index] do
      record.linkedin_url
    end

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ImportLemlist
  end
end
