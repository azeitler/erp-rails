class Avo::Resources::BreakcoldPerson < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::Person
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :title

  def fields
    #field :id, as: :id
    #field :identifier, as: :text
    field :avatar, as: :external_image do
      record.avatar_url
    end
    field :title, as: :text, link_to_record: true
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
    field :tags, as: :tags

    # field :deleted, as: :boolean, name: 'Exists?' do
    #   !record.deleted
    # end
    # field :deleted_at, as: :date# , hide_on: [:index]

    field 'LinkedIn Url', as: :text, hide_on: [:index] do
      record.linkedin_url
    end
    field 'Lists', as: :text do
      record.lists.count
    end

    field :list_ids, as: :key_value, hide_on: [:index] do
      record.list_ids
    end

    field :lists, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldList, reloadable: true

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ImportBreakcoldLeads
  end
end
