class Avo::Resources::InboundWebhook < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :status, as: :select, enum: ::InboundWebhook.statuses
    field :body, as: :textarea
  end
end
