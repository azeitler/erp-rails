class Avo::Resources::BreakcoldCompany < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::Company
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :title

  def fields
    # field :id, as: :id
    # field :identifier, as: :text
    field :avatar, as: :external_image, readonly: true do
      record.avatar_url
    end
    field :title, as: :text, link_to_record: true, readonly: true
    field :email, as: :text, readonly: true
    field 'LinkedIn',
      as: :badge,
      options: {
        success: :profile,
        warning: :salesnav,
        neutral: :missing
      } do
      record.linkedin_type
    end
    field :tags, as: :tags, readonly: true

    field 'LinkedIn Url', as: :text, hide_on: [:index] do
      record.linkedin_url
    end
    field 'Lists', as: :text do
      record.lists.count
    end

    field :lists, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldList, reloadable: true

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end

  def actions
    action Avo::Actions::ImportBreakcoldLeads
    action Avo::Actions::ParseAndSave
  end
end
