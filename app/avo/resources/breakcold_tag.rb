class Avo::Resources::BreakcoldTag < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::Tag
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    # field :id, as: :id
    field :title, as: :text, link_to_record: true
    field :identifier, as: :text

    panel 'Import' do
      field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
        JSON.pretty_generate(value.sort.to_h)
      end
    end
  end
end
