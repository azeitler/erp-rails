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
    field :identifier, as: :text, hide_on: [:index]
    field "Stages", as: :text do
      record.statuses.count
    end
    field :deleted, as: :boolean, name: 'Exists?' do
      !record.deleted
    end


    field :lemlist_campaign, as: :belongs_to, resource: Avo::Resources::LemlistCampaign, link_to_resource: true, searchable: false

    field 'View on Breakcold', as: :text, label: 'View', as_html: true do
      "<a href='#{Breakcold.list_url(record.identifier)}' target='_blank' class='rounded-xl px-4 py-1 bg-gray-700 text-white'>Breakcold ›</a>"
    end

    field 'People', as: :text do
      record.people.count
    end
    field 'Companies', as: :text do
      record.companies.count
    end

    field :people, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldPerson, reloadable: true, link_to_resource: true
    field :companies, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldCompany, reloadable: true, link_to_resource: true

    field :statuses, name: 'Stages', as: :has_many, resource: Avo::Resources::BreakcoldStatus, hide_on: [:index]

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
