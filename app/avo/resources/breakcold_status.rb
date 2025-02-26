class Avo::Resources::BreakcoldStatus < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Breakcold::Status
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :identifier, as: :text
    field :properties, as: :text
    field :title, as: :text
  end
end
