class Avo::Resources::BreakcoldList < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::List
  self.authorization_policy = BreakcoldListPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  self.title = :title

  def fields
    # field :id, as: :id
    field :title, as: :text, link_to_record: true
    field :identifier, as: :text

    field 'People', as: :text do
      record.people.count
    end
    field 'Companies', as: :text do
      record.companies.count
    end

    field :lemlist_campaign, as: :belongs_to, resource: Avo::Resources::LemlistCampaign, link_to_resource: true, searchable: false

    field :people, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldPerson, reloadable: true, link_to_resource: true
    field :companies, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldCompany, reloadable: true, link_to_resource: true

    panel 'Import' do
      field "Properties", as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate(record.properties.sort.to_h)
      end
    end

  end

  def actions
    action Avo::Actions::ImportBreakcoldLists
  end
end
