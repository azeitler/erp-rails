class Avo::Resources::LemlistLead < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  self.model_class = ::Lemlist::Lead
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :identifier, as: :text
    field :properties, as: :text
    field :title, as: :text
    field :email, as: :text
  end
end
