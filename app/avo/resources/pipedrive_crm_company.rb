class Avo::Resources::PipedriveCrmCompany < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::PipedriveCrm::Company
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :identifier, as: :text
    field :issues, as: :textarea
    field :title, as: :text
    field :customer_number, as: :text
    field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
      JSON.pretty_generate(value.sort.to_h)
    end
  end
end
