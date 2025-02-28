class Avo::Resources::BreakcoldStatus < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::Status
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }
  self.title = :title

  def fields
    # field :id, as: :id
    field :title, as: :text, link_to_record: true
    field :instructions, as: :text
    field :color, as: :text, as_html: true do |&args|
      "<div class='flex items-center'><div class='rounded-full' style='padding: 2px 10px; color: #{record.text_color}; background-color: #{record.color};'>#{record.color.upcase}</div></div>"
    end
    field :identifier, as: :text, hide_on: [:index]
    field :order, as: :number
    field :list, as: :belongs_to, resource: Avo::Resources::BreakcoldList, link_to_resource: true, searchable: false

    field 'People', as: :text do
      record.people.count
    end
    field 'Companies', as: :text do
      record.companies.count
    end

    field :people, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldPerson, reloadable: true, link_to_resource: true
    field :companies, as: :has_and_belongs_to_many, use_resource: Avo::Resources::BreakcoldCompany, reloadable: true, link_to_resource: true

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end
end
