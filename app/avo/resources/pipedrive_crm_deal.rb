class Avo::Resources::PipedriveCrmDeal < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::PipedriveCrm::Deal
  self.authorization_policy = ViewOnlyPolicy
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :identifier, as: :text
    field :issues, as: :textarea
    field :title, as: :text
    field :pipeline, as: :text
    field :status, as: :text
    field :value, as: :number
    field :close_date, as: :date_time
    field :year, as: :number
    field :properties, as: :code, theme: 'dracula', language: 'json', readonly: true, format_using: ->  do
      JSON.pretty_generate(value.sort.to_h)
    end
  end
end
