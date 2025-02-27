class Avo::Resources::PipedriveCrmUser < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::PipedriveCrm::User
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :identifier, as: :text
    field :issues, as: :textarea
    field :title, as: :text
    field :email, as: :text
    field :properties, as: :code, theme: 'dracula', language: 'json', format_using: ->  do
      JSON.pretty_generate(value)
    end
  end
end
